clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'vSUB'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% vSUB

regions = cell(5,2);
regions{1,1} = [78 33;85 33;83 39;78 38;76 38;73 37;73 34]; %i=76
regions{2,1} = [74 33;79 32;85 32;83 39;79 39;74 38;71 36]; %i=77
regions{3,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %i=78
regions{4,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %i=79
regions{5,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %i=80


regions{1,2} = [78 139;85 139;83 133;78 134;76 134;73 135;71 138]; %i=76
regions{2,2} = [78 139;85 139;82 133;78 134;76 134;73 135;73 138]; %i=77
regions{3,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %i=78
regions{4,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %i=79
regions{5,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %i=80


%% Show atlas and roi for each slice

slice_counter = 1;
for slice_num = 76:80
    figure
    atlas_view = reshape(atlas(:,slice_num,:),[165,135]);
    imshow(atlas_view,[0,max(atlas_view,[],'all')])
    roi = images.roi.Freehand(gca,'Position',regions{slice_counter,1});
    set(gcf,'Position',[100,100,1800,1000])
    if save_flag == 1
        print(gcf,sprintf('%s/%s_left_%d.tiff',save_path,save_name,slice_num),'-dtiff','-r300')
    end
    figure
    atlas_view = reshape(atlas(:,slice_num,:),[165,135]);
    imshow(atlas_view,[0,max(atlas_view,[],'all')])
    roi = images.roi.Freehand(gca,'Position',regions{slice_counter,2});
    set(gcf,'Position',[100,100,1800,1000])
    if save_flag == 1
        print(gcf,sprintf('%s/%s_right_%d.tiff',save_path,save_name,slice_num),'-dtiff','-r300')
    end
    slice_counter = slice_counter + 1;
end

