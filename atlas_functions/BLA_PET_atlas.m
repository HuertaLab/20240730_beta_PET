function [BLA_PET] = BLA_PET_atlas(PET_scan,MRI_atlas)

save_imgs = 0;

%% Slices

% Column 1 - left
    
regions = cell(12,2);
regions{1,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=106
regions{2,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=107
regions{3,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=108
regions{4,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=109
regions{5,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=110
regions{6,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=111
regions{7,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48;59 46; 67 40]; %slice=112
regions{8,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48; 59 46; 67 40]; %slice=113
regions{9,1} = [76 33;68 32;61 34;54 39;51 43;52 47;54 48; 59 46; 67 40]; %slice=114
regions{10,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %slice=115
regions{11,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %slice=116
regions{12,1} = [71 34;65 34;60 35;54 39;51 43;52 47;54 48; 59 46; 67 40]; %slice=117

% Column 2 - right

regions{1,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=106
regions{2,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=107
regions{3,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=108
regions{4,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=109
regions{5,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=110
regions{6,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=111
regions{7,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=112
regions{8,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=113
regions{9,2} = [76 139;68 140;61 138;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=114
regions{10,2} = [71 138;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=115
regions{11,2} = [71 138;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=116
regions{12,2} = [72 137;65 138;60 137;54 133;51 129;52 125;54 124;59 126;67 132]; %slice=117

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

slice_number = 106;
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

BLA_PET = masked_PET_meanvalue;