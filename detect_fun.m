function [I1,plate] = detect_fun(detector,helmetdetector,platedetector,I)

[bboxes,scores,label] = detect(detector,I);
                    [score,idx] = max(scores);
                    %bboxes = bboxes(idx,:);
                    annotation = sprintf('%s:(Confidence = %f)',label(idx),score);
                    disp(score)
                    disp(label(idx))
                    I1 = insertObjectAnnotation(s(k).cdata,'rectangle',bboxes,annotation);
                    
                    
                    if(isequal(label(idx),'motorcycle'))
                        
                   
                     
                     %imwrite( I,fullfile('D:\Image\images',['Image',int2str(k),'.jpg']));
                     x=bboxes(i,1);
                     y=bboxes(i,2);
                     w=bboxes(i,3);
                     h=bboxes(i,4);
                     motorcycle=imcrop(I1,[x,y,w,h]);
                     motorcycle = imresize(motorcycle,[224 224]);
                    % Run the helmet detector.
                    [helmetbboxes,scores,label] = detect(helmetdetector,motorcycle);
                 
                    if(isequal(label,'head'))
                        ans='WithoutHelmet'
                        
                        [platebboxes,scores,platelabel] = detect(platedetector,motorcycle);
                        if(isequal(platelabel,'YCCplate'))
                        platex=platebboxes(1,1);
                        platey=platebboxes(1,2);
                        platew=platebboxes(1,3);
                        plateh=platebboxes(1,4);
                        plate=imcrop(motorcycle,[platex,platey,platew,plateh]);
                        bigPlate=imresize(plate,[100,200]);
                        
                        
                        
                        %imwrite( bigPlate,fullfile('D:\Image\images\plates',['Image',int2str(k),'.jpg']));
                        end
                        
                        
                    end
                   
                    %imwrite( motorcycle,fullfile('D:\Image\images',['Image',int2str(k),'.jpg']));
                    end


end