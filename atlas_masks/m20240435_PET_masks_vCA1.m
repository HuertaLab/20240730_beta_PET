clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'vCA1'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% vCA1

regions = cell(10,2);
regions{1,1} = [75 30;68 33;62 38;57 44;56 51;57 55;62 50;69 43;77 38]; %i=99
regions{2,1} = [75 30;68 33;62 38;57 44;54 52;55 57;62 50;69 43;77 38]; %i=98
regions{3,1} = [74 30;68 33;62 38;57 44;54 52;55 57;62 50;69 43;77 38]; %i=97
regions{4,1} = [73 30;66 33;62 38;57 44;54 53;55 59;62 50;69 43;74 38]; %i=96
regions{5,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %i=95
regions{6,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %i=94
regions{7,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %i=93
regions{8,1} = [71 31;62 36;59 39;56 45;55 51;56 56;62 48;65 44;70 39]; %i=92
regions{9,1} = [67 32;62 36;59 39;56 42;54 46;59 49;62 47;65 44;70 39]; %i=91
regions{10,1} = [67 32;62 36;59 39;56 42;54 46;59 49;62 47;65 44;70 39]; %i=90


regions{1,2} = [75 142;68 139;62 134;57 128;56 121;57 117;62 122;69 129;77 134]; %i=99
regions{2,2} = [75 142;68 139;62 134;57 128;54 120;55 115;62 122;69 129;77 134]; %i=98
regions{3,2} = [74 142;68 139;62 134;57 128;54 120;55 115;62 122;69 129;77 134]; %i=97
regions{4,2} = [73 142;66 139;62 134;57 128;54 119;55 113;62 122;69 129;74 134]; %i=96
regions{5,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %i=95
regions{6,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %i=94
regions{7,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %i=93
regions{8,2} = [67 140;62 136;59 133;56 127;55 121;56 116;62 124;65 178;70 133]; %i=92
regions{9,2} = [67 140;62 136;59 133;56 130;54 126;59 123;62 125;65 128;70 133]; %i=91
regions{10,2} = [67 140;62 136;59 133;56 130;54 126;59 123;62 125;65 128;70 133];%i=90


%% Show atlas and roi for each slice

slice_counter = 1;
slice_num = 99;
while slice_num >= 90
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
    slice_num = slice_num - 1;
end

