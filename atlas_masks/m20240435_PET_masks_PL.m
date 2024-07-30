clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'PL'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% PL

regions = cell(6,1);
regions{1} = [96 75;96 96;87 96;87 75]; %slice=155
regions{2} = [96 75;96 96;87 96;87 75]; %slice=156
regions{3} = [93 75;93 96;87 96;87 75]; %slice=157
regions{4} = [93 75;93 96;87 96;87 75]; %slice=158
regions{5} = [93 75;93 96;87 96;87 75]; %slice=159
regions{6} = [93 75;93 96;87 96;87 75]; %slice=160


%% Show atlas and roi for each slice

slice_counter = 1;
for slice_num = 155:160
    figure
    atlas_view = reshape(atlas(:,slice_num,:),[165,135]);
    imshow(atlas_view,[0,max(atlas_view,[],'all')])
    roi = images.roi.Freehand(gca,'Position',regions{slice_counter});
    set(gcf,'Position',[100,100,1800,1000])
    if save_flag == 1
        print(gcf,sprintf('%s/%s_%d.tiff',save_path,save_name,slice_num),'-dtiff','-r300')
    end
end

