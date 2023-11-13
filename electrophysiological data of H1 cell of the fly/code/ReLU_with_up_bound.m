function y = ReLU_with_up_bound(x,up_bound)

x(x<0) = 0;
x(x>up_bound) = up_bound;
y = x;

end