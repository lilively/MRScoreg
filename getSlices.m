function getSlices(imPath, maskPath, outF)
    set(0, 'DefaultFigureVisible', 'off');
    [~, caseNum, ~] = fileparts(imPath);
    image = niftiread(imPath);
    mask = niftiread(maskPath);
    loop = size(mask);
    counter = loop(2);
    
    % Store figure handles to close later
    figuresToClose = [];
    
    % Iterate through the 512 slices
    for i = 1:counter
        masks = squeeze((mask(:,i,:)));
        isinside = sum(sum(masks));
        
        if isinside > 0
            BW = masks;
            rot = flipdim(BW, 2);
            corres = squeeze((image(:,i,:)));
            rotcor = flipdim(corres, 2);
            
            if sum(sum(rot)) > 0
                h1 = figure;
                figuresToClose(end+1) = h1;
                imshow(rotcor, []);
                corners = pgonCorners(rot, 4, 360);
                
                if size(corners) ~= [4,4]
                    continue
                else
                    % Original Coordinates (Before Angulation)
                    h2 = figure;
                    figuresToClose(end+1) = h2;
                    imshow(rot, []);
                    hold on
                    plot(corners(:,2), corners(:,1), 'yo', 'MarkerFaceColor', 'r', ...
                         'MarkerSize', 12, 'LineWidth', 2);
                    hold off
                    
                    maskedRgbImage = bsxfun(@times, rotcor, cast(rot, 'like', rotcor));
                    h3 = figure;
                    figuresToClose(end+1) = h3;
                    imshow(maskedRgbImage, [])
                    title('masked')
                    
                    % Angulation starts
                    slope_pt1 = corners(3,1);
                    slope_pt2 = corners(4,1);
                    slope_pt3 = corners(3,2);
                    slope_pt4 = corners(4,2);
                    slope = atand((slope_pt1-slope_pt2)/(slope_pt3-slope_pt4));

                    if abs(slope) > 2
                        fprintf('TILTED: Slice %d, Case %s, Angle: %.1f°\n', i, caseNum, slope);
                    end
                    
                    rotated_mask = imrotate(rot, slope);
                    h4 = figure;
                    figuresToClose(end+1) = h4;
                    imshow(rotated_mask, []);
                    [new_r, new_c] = size(rotated_mask);
                    rotated_image = imrotate(rotcor, slope);
                    rotated_image = imresize(rotated_image, [new_r new_c]);
                    corners = pgonCorners(rotated_mask, 4, 360);
                    
                    counter = counter + 1;
                    
                    if size(corners) ~= [4,4]
                        continue
                    else
                        xbig = round(corners(2,1));
                        xsmall = round(corners(3,1));
                        ybig = round(corners(3,2));
                        ysmall = round(corners(4,2));
                        resize_gray = rotated_image(xsmall:xbig, ysmall:ybig, :);
                        
                        if isempty(resize_gray)
                            continue
                        else
                            save_grid = imresize(resize_gray, 3);
                            save_grid = rescale(save_grid);
                            h5 = figure;
                            figuresToClose(end+1) = h5;
                            imshow(save_grid, [])
                            
                            final_save = save_grid;
                            h6 = figure;
                            figuresToClose(end+1) = h6;
                            imshow(final_save, [])
                            
                            % Close only the figures created in this function
                            delete(figuresToClose);
                            figuresToClose = []; % Reset for next iteration
                            
                            subfolder_name = caseNum;
                            newDir = fullfile(outF, subfolder_name, 'All');
                            
                            if ~exist(newDir, 'dir')
                                mkdir(newDir)
                                fprintf('\nDirectory created: %s', newDir)
                            end
                            
                            outname = sprintf('%s-%d.png', caseNum, i);
                            % outname = sprintf('%s-%d-a%.0f.png', caseNum, i, slope);
                            outpath = fullfile(newDir, outname);
                            imwrite(final_save, outpath, 'BitDepth', 16);
                            fprintf('\nImage saved to: %s', outpath);
                        end
                    end
                end
            end
        end
    end
end