function [MEC_PET] = MEC_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(15,2);
regions{1,1} = [78 30;84 30;89 32;93 35;95 40;93 45;85 43;78 39;75 34;]; %slice=67
regions{2,1} = [77 29;83 29;89 32;93 35;94 40;91 45;83 44;76 39;73 34]; %slice=68
regions{3,1} = [76 29;83 29;88 31;92 35;93 40;91 45;83 44;74 40;71 33]; %slice=69
regions{4,1} = [76 29;83 29;88 31;92 35;93 40;91 45;83 44;74 40;71 33]; %slice=70
regions{5,1} = [73 28;80 29;85 31;89 35;91 41;89 46;79 45;69 40;68 32]; %slice=71
regions{6,1} = [73 28;80 29;85 31;89 35;91 41;89 46;79 45;69 40;68 32]; %slice=72
regions{7,1} = [70 32;77 33;83 34;88 38;89 42;85 46;76 46;65 42;63 35]; %slice=73
regions{8,1} = [67 36;72 37;78 39;82 41;86 43;84 46;74 46;64 43;62 38]; %slice=74
regions{9,1} = [67 36;72 37;78 39;82 41;86 43;84 46;74 46;64 43;62 38]; %slice=75
regions{10,1} = [58 37;68 36;66 41;64 46;59 44]; %slice=76
regions{11,1} = [57 38;65 37;66 43;62 46;57 43]; %slice=77
regions{12,1} = [57 38;65 37;66 43;62 46;57 43]; %slice=78
regions{13,1} = [55 38;62 38;61 43;59 47;54 43]; %slice=79
regions{14,1} = [55 38;62 38;61 43;59 47;54 43]; %slice=80
regions{15,1} = [55 38;62 38;61 43;59 47;54 43]; %slice=81

% Column 2 - right

regions{1,2} = [78 142;84 142;89 140;93 137;95 132;93 127;85 129;78 133;75 138]; %slice=67
regions{2,2} = [77 143;83 143;89 140;93 137;94 132;91 127;83 128;76 133;73 138]; %slice=68
regions{3,2} = [76 143;83 143;88 141;92 137;93 132;91 127;83 128;74 132;71 139]; %slice=69
regions{4,2} = [76 143;83 143;88 141;92 137;93 132;91 127;83 128;74 132;71 139]; %slice=70
regions{5,2} = [73 144;80 143;85 141;89 137;91 131;89 126;79 127;69 132;68 140]; %slice=71
regions{6,2} = [73 144;80 143;85 141;89 137;91 131;89 126;79 127;69 132;68 140]; %slice=72
regions{7,2} = [70 140;77 139;83 138;88 134;89 130;85 126;76 126;65 130;63 137]; %slice=73
regions{8,2} = [67 136;72 135;78 133;82 131;86 129;84 126;74 126;64 129;62 134]; %slice=74
regions{9,2} = [67 136;72 135;78 133;82 131;86 129;84 126;74 126;64 129;62 134]; %slice=75
regions{10,2} = [67 136;72 135;78 133;82 131;59 129];%slice=76
regions{11,2} = [58 135;68 136;66 131;64 126;59 128];%slice=77
regions{12,2} = [58 135;68 136;66 131;64 126;59 128];%slice=78
regions{13,2} = [55 134;62 134;61 129;59 125;54 129];%slice=79
regions{14,2} = [55 134;62 134;61 129;59 125;54 129];%slice=80
regions{15,2} = [55 134;62 134;61 129;59 125;54 129];%slice=81

%% Import atlas, set all values outside of brain to 0
atlas_mask = MRI_atlas;
atlas_mask(atlas_mask<100) = 0;
atlas_mask(atlas_mask>100) = 1;

% Set all PET values outside of MRI atlas and PET brain area to 0
PET_scan(atlas_mask == 0) = 0;  

% Get average for whole brain
% need to delete values outside brain

% Calculate whole brain mean PET value
whole_brain_mean = mean(PET_scan(PET_scan>1e7));

masked_PET = cell(size(regions));
masked_PET_bilateral = cell(size(regions));
masked_PET_nozeros = cell(size(regions));
masked_PET_meanvalue = zeros(size(regions));

slice_number = 67;
% Loop for each slice
for islice = 1:size(regions,1)

    % Isolate single slice
    PET_scan_slice = reshape(PET_scan(:,slice_number,:),[165,135]);

    % Create image of PET scan slice
    % figure
    imshow(PET_scan_slice,[0,max(PET_scan_slice,[],'all')],Colormap=jet)

    % Draw region of interest for left side (column 1 of regions)
    roi_1 = images.roi.Freehand(gca,'Position',regions{islice,1});

    % Create mask for region (left side)
    mask_1 = createMask(roi_1,PET_scan_slice);

    % Apply mask to PET data (left)
    masked_PET{islice,1} = double(PET_scan_slice).*double(mask_1);

    % Normalize PET slice to whole brain mean (left)
    masked_PET{islice,1} = masked_PET{islice,1}./whole_brain_mean;

    % Draw region of interest for right side (column 2 of regions)% Create image of PET scan slice
    % figure
    imshow(PET_scan_slice,[0,max(PET_scan_slice,[],'all')],Colormap=jet)
    roi_2 = images.roi.Freehand(gca,'Position',regions{islice,2});

    % Create mask for region (right side)
    mask_2 = createMask(roi_2,PET_scan_slice);

    % Apply mask to PET data (right)
    masked_PET{islice,2} = double(PET_scan_slice).*double(mask_2);

    % Normalize PET slice to whole brain mean (right)
    masked_PET{islice,2} = double(masked_PET{islice,2})./whole_brain_mean;

    % Get mean value for each slice
    masked_PET_nozeros{islice,1} = masked_PET{islice,1}(masked_PET{islice,1}~=0);
    masked_PET_nozeros{islice,2} = masked_PET{islice,2}(masked_PET{islice,2}~=0);
    masked_PET_meanvalue(islice,1) = mean(masked_PET_nozeros{islice,1});
    masked_PET_meanvalue(islice,2) = mean(masked_PET_nozeros{islice,2});

    % Masked PET both sides
    masked_PET_bilateral{islice} = masked_PET{islice,1} + masked_PET{islice,2};

    % Atlas slice
    atlas_slice = reshape(MRI_atlas(:,slice_number,:),[165,135]);

    % Show atlas slice
    % figure
    % imshow(atlas_slice,[0,max(atlas_slice,[],'all')]);

    if save_imgs == 1
        print(gcf,sprintf('%s/%s_atlas_%d.tiff',save_folder,group_name,slice_number),'-dtiff','-r300')
    end
    % Show image of masked PET
    % figure
    % imshow(masked_PET_bilateral{islice},[],Colormap=jet,DisplayRange=[0.6,1.1])

    if save_imgs == 1
        print(gcf,sprintf('%s/%s_PET_%d.tiff',save_folder,group_name,slice_number),'-dtiff','-r300')
    end
    
    slice_number = slice_number + 1;

end



% output

MEC_PET = masked_PET_meanvalue;