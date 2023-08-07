% 使用cellfun和vertcat将所有元素合并为一个列向量
result = cellfun(@(x) x(:), Poisson_process_ext_, 'UniformOutput', false);
result = vertcat(result{:});
figure;
histogram(result);