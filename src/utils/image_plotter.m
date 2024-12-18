function [] = image_plotter(img, points, lines, points_label)
    % Plot the image with a set of lines and points 

    
    figure();
    imshow(img);
    hold on;
    impixelinfo;
    
    for k = 1:size(lines, 1)
        line_plotter(lines(k, :))
    end 

    for k = 1:size(points, 1)
        point_plotter(points(k, :))
        if (points_label ~= 0)
            text(points(k, 1), points(k, 2), num2str(k), 'Color', 'black', 'FontSize', 20);
        end 
    end
    hold off;
end