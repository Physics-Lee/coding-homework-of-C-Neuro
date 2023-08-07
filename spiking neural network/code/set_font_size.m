function set_font_size(ax, size)
    % 设置x轴和y轴标签的字体大小
    ax.XLabel.FontSize = size;
    ax.YLabel.FontSize = size;

    % 设置标题的字体大小
    ax.Title.FontSize = size;

    % 设置x轴和y轴刻度的字体大小
    ax.XAxis.FontSize = size;
    ax.YAxis.FontSize = size;
end