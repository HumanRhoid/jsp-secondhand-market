package com.market.common;

import javax.servlet.Filter;
import javax.servlet.annotation.WebFilter;

@WebFilter("/*")
public class EncodingFilter implements Filter {

}
