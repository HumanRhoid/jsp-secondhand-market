package com.market.common;

import javax.servlet.Filter;
import javax.servlet.annotation.WebFilter;

@WebFilter(urlPatterns = {"/product/form", "/product/write", "/user/profile"})
public class LoginCheckFilter implements Filter {

}
