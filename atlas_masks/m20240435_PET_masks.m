clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'BLA'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% BLA

regions = cell(12,2);
regions{1,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=106
regions{2,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=107
regions{3,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=108
regions{4,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=109
regions{5,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=110
regions{6,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=111
regions{7,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %i=112
regions{8,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48; 59 46; 67 40]; %i=113
regions{9,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48; 59 46; 67 40]; %i=114
regions{10,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %i=115
regions{11,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %i=116
regions{12,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %i=117


regions{1,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=106
regions{2,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=107
regions{3,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=108
regions{4,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=109
regions{5,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=110
regions{6,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=111
regions{7,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=112
regions{8,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=113
regions{9,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %i=114
regions{10,2} = [71 138;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %i=115
regions{11,2} = [71 138;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %i=116
regions{12,2} = [72 137;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %i=117


%% Show atlas and roi for each slice

slice_counter = 1;
for slice_num = 106:117
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

