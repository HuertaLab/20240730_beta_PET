function [LEC_PET] = LEC_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(10,2);
regions{1,1} = [61 31;65 26;69 24;75 22;78 31;73 33;69 35]; %slice=75
regions{2,1} = [61 31;65 26;69 24;75 22;78 31;73 33;69 35]; %slice=76
regions{3,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %slice=77
regions{4,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %slice=78
regions{5,1} = [61 31;65 26;69 24;75 22;77 29;72 31;68 34]; %slice=79
regions{6,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %slice=80
regions{7,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %slice=81
regions{8,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %slice=82
regions{9,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %slice=83
regions{10,1} = [57 31;61 26;66 23;72 21;73 28;68 30;64 33]; %slice=84

% Column 2 - right

regions{1,2} = [61 141;65 146;69 148;75 150;78 141;73 139;69 137]; %slice=75
regions{2,2} = [61 141;65 146;69 148;75 150;78 141;73 139;69 137]; %slice=76
regions{3,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %slice=77
regions{4,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %slice=78
regions{5,2} = [61 141;65 146;69 148;75 150;77 143;72 141;68 138]; %slice=79
regions{6,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %slice=80
regions{7,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %slice=81
regions{8,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %slice=82
regions{9,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139]; %slice=83
regions{10,2} = [57 141;61 146;66 149;72 151;73 144;68 142;64 139];%slice=84

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

slice_number = 75;
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

LEC_PET = masked_PET_meanvalue;