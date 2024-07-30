function [PL_PET] = PL_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

regions = cell(6,1);
regions{1} = [96 75;96 96;87 96;87 75]; %slice=155
regions{2} = [96 75;96 96;87 96;87 75]; %slice=156
regions{3} = [93 75;93 96;87 96;87 75]; %slice=157
regions{4} = [93 75;93 96;87 96;87 75]; %slice=158
regions{5} = [93 75;93 96;87 96;87 75]; %slice=159
regions{6} = [93 75;93 96;87 96;87 75]; %slice=160

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
masked_PET_nozeros = cell(size(regions));
masked_PET_meanvalue = zeros(size(regions));

slice_number = 155;
% Loop for each slice
for islice = 1:size(regions,1)

    % Isolate single slice
    PET_scan_slice = reshape(PET_scan(:,slice_number,:),[165,135]);

    % Create image of PET scan slice
    % figure
    imshow(PET_scan_slice,[0,max(PET_scan_slice,[],'all')],Colormap=jet)

    % Draw region of interest
    roi_1 = images.roi.Freehand(gca,'Position',regions{islice,1});

    % Create mask for region
    mask_1 = createMask(roi_1,PET_scan_slice);

    % Apply mask to PET data
    masked_PET{islice,1} = double(PET_scan_slice).*double(mask_1);

    % Normalize PET slice to whole brain mean
    masked_PET{islice,1} = masked_PET{islice,1}./whole_brain_mean;

    % Get mean value for each slice
    masked_PET_nozeros{islice,1} = masked_PET{islice,1}(masked_PET{islice,1}~=0);
    masked_PET_meanvalue(islice,1) = mean(masked_PET_nozeros{islice,1});

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
    % imshow(masked_PET{islice,1},[],Colormap=jet,DisplayRange=[0.6,1.1])

    if save_imgs == 1
        print(gcf,sprintf('%s/%s_PET_%d.tiff',save_folder,group_name,slice_number),'-dtiff','-r300')
    end
    
    slice_number = slice_number + 1;

end



% output

PL_PET = masked_PET_meanvalue;