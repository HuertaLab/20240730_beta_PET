function [vCA1_PET] = vCA1_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(10,2);
regions{1,1} = [75 30;68 33;62 38;57 44;56 51;57 55;62 50;69 43;77 38]; %slice=99
regions{2,1} = [75 30;68 33;62 38;57 44;54 52;55 57;62 50;69 43;77 38]; %slice=98
regions{3,1} = [74 30;68 33;62 38;57 44;54 52;55 57;62 50;69 43;77 38]; %slice=97
regions{4,1} = [73 30;66 33;62 38;57 44;54 53;55 59;62 50;69 43;74 38]; %slice=96
regions{5,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %slice=95
regions{6,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %slice=94
regions{7,1} = [71 31;64 34;60 38;56 45;54 53;55 59;62 49;66 44;72 39]; %slice=93
regions{8,1} = [71 31;62 36;59 39;56 45;55 51;56 56;62 48;65 44;70 39]; %slice=92
regions{9,1} = [67 32;62 36;59 39;56 42;54 46;59 49;62 47;65 44;70 39]; %slice=91
regions{10,1} = [67 32;62 36;59 39;56 42;54 46;59 49;62 47;65 44;70 39]; %slice=90
% Column 2 - right

regions{1,2} = [75 142;68 139;62 134;57 128;56 121;57 117;62 122;69 129;77 134]; %slice=99
regions{2,2} = [75 142;68 139;62 134;57 128;54 120;55 115;62 122;69 129;77 134]; %slice=98
regions{3,2} = [74 142;68 139;62 134;57 128;54 120;55 115;62 122;69 129;77 134]; %slice=97
regions{4,2} = [73 142;66 139;62 134;57 128;54 119;55 113;62 122;69 129;74 134]; %slice=96
regions{5,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %slice=95
regions{6,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %slice=94
regions{7,2} = [71 141;64 138;60 134;56 127;54 119;55 113;62 123;66 128;72 133]; %slice=93
regions{8,2} = [67 140;62 136;59 133;56 127;55 121;56 116;62 124;65 128;70 133]; %slice=92
regions{9,2} = [67 140;62 136;59 133;56 130;54 126;59 123;62 125;65 128;70 133]; %slice=91
regions{10,2} = [67 140;62 136;59 133;56 130;54 126;59 123;62 125;65 128;70 133];%slice=90

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

slice_number = 99;
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
    
    slice_number = slice_number - 1;

end



% output

vCA1_PET = masked_PET_meanvalue;