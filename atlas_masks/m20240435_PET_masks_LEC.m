clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'LEC'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% LEC

regions = cell(10,2);
regions{1,1} = [61 31;65 26;69 24;75 22;78 31;73 33;69 35]; %i=75
regions{2,1} = [61 31;65 26;69 24;75 22;78 31;73 33;69 35]; %i=76
regions{3,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %i=77
regions{4,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %i=78
regions{5,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %i=79
regions{6,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %i=80
regions{7,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %i=81
regions{8,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %i=82
regions{9,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %i=83
regions{10,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %i=84


regions{1,2} = [61 141;65 146;69 148;75 150;78 141;73 139;69 137]; %i=75
regions{2,2} = [61 141;65 146;69 148;75 150;78 141;73 139;69 137]; %i=76
regions{3,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %i=77
regions{4,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %i=78
regions{5,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %i=79
regions{6,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %i=80
regions{7,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %i=81
regions{8,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %i=82
regions{9,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %i=83
regions{10,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139];%i=84


%% Show atlas and roi for each slice

slice_counter = 1;
for slice_num = 75:84
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

