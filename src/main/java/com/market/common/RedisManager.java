package com.market.common;

import java.util.ArrayList;
import java.util.List;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * Redis 연결 관리자.
 * 기획서 3-1 "데이터베이스 분리 운영" 구현체 —
 * 영속성이 필요한 데이터는 PostgreSQL, 빈번한 실시간 연산(조회수 랭킹)은 Redis로 분리한다.
 * Redis가 꺼져 있어도 서비스가 죽지 않도록 모든 메서드는 실패 시 조용히 폴백한다.
 */
public class RedisManager {

    private static final String HOST = "localhost";
    private static final int    PORT = 6379;
    private static final String RANK_KEY = "product:rank";

    private static JedisPool pool;
    // 장애 시 매 요청마다 재접속을 시도하지 않도록 30초간 비활성 처리
    private static long retryAfter = 0;

    private static synchronized JedisPool getPool() {
        if (pool == null) {
            JedisPoolConfig config = new JedisPoolConfig();
            config.setMaxTotal(20);
            config.setMaxIdle(5);
            pool = new JedisPool(config, HOST, PORT, 2000);
        }
        return pool;
    }

    private static boolean isDown() {
        return System.currentTimeMillis() < retryAfter;
    }

    private static void markDown() {
        retryAfter = System.currentTimeMillis() + 30_000;
    }

    /** 상품 조회 시 인기 랭킹 점수 1 증가 */
    public static void incrementProductRank(long productId) {
        if (isDown()) return;
        try (Jedis jedis = getPool().getResource()) {
            jedis.zincrby(RANK_KEY, 1, String.valueOf(productId));
        } catch (Exception e) {
            System.out.println("Redis incrementProductRank 실패(폴백): " + e.getMessage());
            markDown();
        }
    }

    /** 조회수 상위 상품 id를 점수 높은 순으로 반환 (Redis 장애 시 빈 목록) */
    public static List<Long> getTopProductIds(int count) {
        List<Long> ids = new ArrayList<>();
        if (isDown()) return ids;
        try (Jedis jedis = getPool().getResource()) {
            for (String member : jedis.zrevrange(RANK_KEY, 0, count - 1))
                ids.add(Long.parseLong(member));
        } catch (Exception e) {
            System.out.println("Redis getTopProductIds 실패(폴백): " + e.getMessage());
            markDown();
        }
        return ids;
    }

    /** 삭제된 상품을 랭킹에서 제거 */
    public static void removeProductRank(long productId) {
        if (isDown()) return;
        try (Jedis jedis = getPool().getResource()) {
            jedis.zrem(RANK_KEY, String.valueOf(productId));
        } catch (Exception e) {
            System.out.println("Redis removeProductRank 실패(폴백): " + e.getMessage());
            markDown();
        }
    }

    /** 연결 상태 확인 (점검용) */
    public static boolean ping() {
        try (Jedis jedis = getPool().getResource()) {
            return "PONG".equalsIgnoreCase(jedis.ping());
        } catch (Exception e) {
            return false;
        }
    }
}
