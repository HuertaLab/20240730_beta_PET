function [vSUB_PET] = vSUB_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(5,2);
regions{1,1} = [78 33;85 33;83 39;78 38;76 38;73 37;73 34]; %slice=76
regions{2,1} = [74 33;79 32;85 32;83 39;79 39;74 38;71 36]; %slice=77
regions{3,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %slice=78
regions{4,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %slice=79
regions{5,1} = [70 37;73 33;79 32;86 33;90 37;88 43;80 40]; %slice=80
% Column 2 - right

regions{1,2} = [78 139;85 139;83 133;78 134;76 134;73 135;71 138]; %slice=76
regions{2,2} = [78 139;85 139;82 133;78 134;76 134;73 135;73 138]; %slice=77
regions{3,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %slice=78
regions{4,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %slice=79
regions{5,2} = [70 135;73 139;79 140;86 139;90 135;88 129;80 132]; %slice=80

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

slice_number = 76;
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

vSUB_PET = masked_PET_meanvalue;