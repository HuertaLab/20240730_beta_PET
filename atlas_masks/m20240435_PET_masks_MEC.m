clear 
close all
clc
%% Load atlas

% path to MRI template - must include hdr and img files
atlas = niftiread('/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.hdr', ...
        '/Users/jstrohl/Documents/20230908 Pipelines for neural data analysis/Dependencies/ATLAS-MICE 2/2011-10-30_MRI-template3.img');

save_path = '/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/20240425 Atlas'
save_name = 'MEC'

save_flag = 1;

%% Define atlas-based regions to analyze

% column 1 is left column 2 is right

% MEC

regions = cell(15,2);
regions{1,1} = [78 30;84 30;89 32;93 35;95 40;93 45;85 43;78 39;75 34;]; %i=67
regions{2,1} = [77 29;83 29;89 32;93 35;94 40;91 45;83 44;76 39;73 34]; %i=68
regions{3,1} = [76 29;83 29;88 31;92 35;93 40;91 45;83 44;74 40;71 33]; %i=69
regions{4,1} = [76 29;83 29;88 31;92 35;93 40;91 45;83 44;74 40;71 33]; %i=70
regions{5,1} = [73 28;80 29;85 31;89 35;91 41;89 46;79 45;69 40;68 32]; %i=71
regions{6,1} = [73 28;80 29;85 31;89 35;91 41;89 46;79 45;69 40;68 32]; %i=72
regions{7,1} = [70 32;77 33;83 34;88 38;89 42;85 46;76 46;65 42;63 35]; %i=73
regions{8,1} = [67 36;72 37;78 39;82 41;86 43;84 46;74 46;64 43;62 38]; %i=74
regions{9,1} = [67 36;72 37;78 39;82 41;86 43;84 46;74 46;64 43;62 38]; %i=75
regions{10,1} = [58 37;68 36;66 41;64 46;59 44]; %i=76
regions{11,1} = [57 38;65 37;66 43;62 46;57 43]; %i=77
regions{12,1} = [57 38;65 37;66 43;62 46;57 43]; %i=78
regions{13,1} = [55 38;62 38;61 43;59 47;54 43]; %i=79
regions{14,1} = [55 38;62 38;61 43;59 47;54 43]; %i=80
regions{15,1} = [55 38;62 38;61 43;59 47;54 43]; %i=81


regions{1,2} = [78 142;84 142;89 140;93 137;95 132;93 127;85 129;78 133;75 138]; %i=67
regions{2,2} = [77 143;83 143;89 140;93 137;94 132;91 127;83 128;76 133;73 138]; %i=68
regions{3,2} = [76 143;83 143;88 141;92 137;93 132;91 127;83 128;74 132;71 139]; %i=69
regions{4,2} = [76 143;83 143;88 141;92 137;93 132;91 127;83 128;74 132;71 139]; %i=70
regions{5,2} = [73 144;80 143;85 141;89 137;91 131;89 126;79 127;69 132;68 140]; %i=71
regions{6,2} = [73 144;80 143;85 141;89 137;91 131;89 126;79 127;69 132;68 140]; %i=72
regions{7,2} = [70 140;77 139;83 138;88 134;89 130;85 126;76 126;65 130;63 137]; %i=73
regions{8,2} = [67 136;72 135;78 133;82 131;86 129;84 126;74 126;64 129;62 134]; %i=74
regions{9,2} = [67 136;72 135;78 133;82 131;86 129;84 126;74 126;64 129;62 134]; %i=75
regions{10,2} = [67 136;72 135;78 133;82 131;86 129];%i=76
regions{11,2} = [58 135;68 136;66 131;64 126;59 128];%i=77
regions{12,2} = [58 135;68 136;66 131;64 126;59 128];%i=78
regions{13,2} = [55 134;62 134;61 129;59 125;54 129];%i=79
regions{14,2} = [55 134;62 134;61 129;59 125;54 129];%i=80
regions{15,2} = [55 134;62 134;61 129;59 125;54 129];%i=81


%% Show atlas and roi for each slice

slice_counter = 1;
for slice_num = 67:81
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

