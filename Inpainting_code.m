close all
clear

% Read in the picture
original = double(imread('greece.tif'));

% Read in the magic forcing function
load forcing;

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the
% pixels are missing in badicture
mask = double(imread('badpixels.tif'));

% Please initialise your variables here (see the instructions for the specific variable names)
total_iterations = 2000;
alpha = 1;

restored = badpic;% initialise the restored pictures to be the badpicture to start with
restored2 = badpic;
% ... You need to initialise the other restored picture, and the error vectors as well
restored20 = badpic;
restored20_2 = badpic;

err = [1, total_iterations];
err2 = [1, total_iterations];

% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));

% Display the corrupted picture in Figure 2
figure(2);
image(badpic);
title('Corrupted Picture');
colormap(gray(256));
    

% Here is where you can do your picture iterations.
% To speed things up use "find" to find the locations of the missing pixels
[j, i] = find(mask == 1); % This stores all the locations in vectors i and j (row and column indices for each missing pixel)
% You might want to also store those locations in a different format

%to store error in each pixel iteration
diff = [1, length(j)];

for iteration = 1 : total_iterations
  diff = zeros(1, length(j));%clear diff array to be filled in next loop
   
  for k = 1 : length(j)
    error = restored(j(k)-1, i(k)) + restored(j(k)+1, i(k)) + ... 
    restored(j(k),i(k)-1) + restored(j(k),i(k)+1) - 4*restored(j(k),i(k));
   
    restored(j(k), i(k)) = restored(j(k), i(k)) + (alpha*error)/4;
    diff(1, k) = restored(j(k), i(k)) - original(j(k), i(k));
  end
  
  if iteration == 20
    restored20 = restored;
  end
  
  err(1, iteration) = std(diff);
end

% Display the restored image in Figure 3 (This does NOT use the forcing function)
figure(3);
image(restored);
title('Restored Picture');
colormap(gray(256));

diff2 = [1, length(j)];

% Now repeat the restoration, again starting from the badpicture, but now use the forcing function in your update
for iteration = 1 : total_iterations
  diff2 = zeros(1, length(j));
    
  for k = 1 : length(j)
    error = restored2(j(k)-1, i(k)) + restored2(j(k)+1, i(k)) + restored2(j(k),i(k)-1) + ...
    restored2(j(k),i(k)+1) - 4*restored2(j(k),i(k)) - f(j(k),i(k));
 
    restored2(j(k), i(k)) = restored2(j(k), i(k)) + (alpha*error)/4;
    diff2(1, k) = original(j(k), i(k)) - restored2(j(k), i(k));
  end
   
  if iteration == 20
    restored20_2 = restored;
  end
   
  err2(1, iteration) = std(diff2);
end

% Display your restored image with forcing function as Figure 4
figure(4);
image(restored2);
title('Restored Picture (with F)');
colormap(gray(256));

% And plot your two error vectors versus iteration
figure(5);
x = (1: total_iterations);
plot(x ,err ,'r-' ,x ,err2 ,'b-' ,'linewidth' ,3);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);
