clc;
clearvars;

thickness = 0.2;
layers = 20;
cube_size = 10;
color = [0 0.5 1];
edge_color = [0 0.3 0.8]; % Darker blue for edges
line_width = 2;

hold on;
for i = 1:layers
    z_bottom = (i-1) * thickness;
    z_top = z_bottom + thickness;

    x = [0 cube_size cube_size 0];
    y = [0 0 cube_size cube_size];

    % Bottom face with thin edge
    patch(x, y, [z_bottom z_bottom z_bottom z_bottom], color, ...
          'EdgeColor', edge_color, 'LineWidth', line_width);

    % Top face with thin edge
    patch(x, y, [z_top z_top z_top z_top], color, ...
          'EdgeColor', edge_color, 'LineWidth', line_width);
end

xlim([0, cube_size])
ylim([0, cube_size])
zlim([0, layers * thickness])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'ZTick',[])
view(45, 30);
% 
% 
% 
% % % % % % % 
% thickness = 0.2;
% layers = 50;
% cube_size = 10;
% color = [0 0.5 1]; % Light blue
% 
% hold on;
% for i = 1:layers
%     z_bottom = (i-1) * thickness;
%     z_top = z_bottom + thickness;
% 
%     % Bottom face (solid fill)
%     x_face = [0 cube_size cube_size 0];
%     y_face = [0 0 cube_size cube_size];
%     fill3(x_face, y_face, [z_bottom z_bottom z_bottom z_bottom], color);
% 
%     % Top face (solid fill)
%     fill3(x_face, y_face, [z_top z_top z_top z_top], color);
% end
% 
% xlim([0, cube_size])
% ylim([0, cube_size])
% zlim([0, layers * thickness])
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% set(gca,'ZTick',[])
% view(45, 30);








% colors = [
%     1 0 0;    % Red
%     1 0.5 0;  % Orange  
%     1 1 0;    % Yellow
%     0 1 0;    % Green
%     0 1 1;    % Cyan
%     0 0 1;    % Blue
%     0.5 0 1;  % Purple
%     1 0 1;    % Magenta
% ];
% 
% alphav = 0.2;
% thickness = 0.1;
% 
% for i = 1:8
%     z_position = (i-1) * thickness;  % Stack them with no gaps
%     plotcube([8 8 thickness], [0 0 z_position], alphav, [1 1 1]);
% end

% % % alphav = 0.3;     % Slightly more opaque
% % % thickness = 0.2; % Very thin layers
% % % layers = 50;     % Many layers
% % % cube_size = 10;
% % % color = [0 0.5 1]; % Light blue
% % % 
% % % for i = 1:layers
% % %     z_position = (i-1) * thickness;
% % %     plotcube([cube_size cube_size thickness], [0 0 z_position], alphav, color);
% % % end
% % % 
% % % total_height = layers * thickness;
% % % xlim([0, cube_size])
% % % ylim([0, cube_size])
% % % zlim([0, total_height])
% % % 
% % % set(gca,'XTick',[])
% % % set(gca,'YTick',[])
% % % set(gca,'ZTick',[])


% % plotcube([8 8 8],[0 0 0],.9,[1 1 0]);
% 
% alphav = .2
% 
% plotcube([8 8 1],[0 0 7],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 6],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 5],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 4],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 3],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 2],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 1],alphav,[1 1 1]);
% plotcube([8 8 1],[0 0 0],alphav,[1 1 1]);
% 
% 
% 
% xlim([0,8])
% set(gca,'XTick',[])
% ylim([0,8])
% set(gca,'YTick',[])
% zlim([0,8])
% set(gca,'ZTick',[])
% 
% view(30,30)

% 
% i = 0:1:2;
% [X Y] = meshgrid(i,i);                         
% x = [X(:) X(:)]';                                
% y = [Y(:) Y(:)]';
% z = [repmat(i(1),1,length(x)); repmat(i(end),1,length(x))];
% col = 'b';
% hold on;
% plot3(x,y,z,col);                                         
% plot3(y,z,x,col);
% plot3(z,x,y,col);
% view(30,30)

% clf
% figure(1)
% for g = 0:1:8
% for i = 0:1:8
% 
%    plot3([g g], [0 8], [i, i])
%    hold on
% end
% end
% 
% for g = 0:1:8
% for i = 0:1:8
% 
%    plot3([0 8], [g g], [i, i])
%    hold on
% end
% end
% 
% for g = 0:1:8
% for i = 0:1:8
% 
%    plot3([i i], [g g], [0 8])
%    hold on
% end
% end

% 
% % 
% clear all 
% close all
% clc
% number = 8
% Nx = number;
% Ny=number;
% Nz=number;
% clf
% hold on
% [i,j]=meshgrid(1:Nx,1:Ny);
% k=zeros(Ny,Nx)+Nz;
% surf(i,j,k)
% [i,k]=meshgrid(1:Nx,1:Nz);
% j=zeros(Nz,Nx)+Ny;
% surf(i,j,k)
% [j,k]=meshgrid(1:Ny,1:Nz);
% i=zeros(Nz,Ny)+Nx;
% surf(i,j,k)
% [i,j]=meshgrid(1:Nx,1:Ny);
% k=zeros(Ny,Nx)+1;
% surf(i,j,k)
% [i,k]=meshgrid(1:Nx,1:Nz);
% j=zeros(Nz,Nx)+1;
% surf(i,j,k)
% [j,k]=meshgrid(1:Ny,1:Nz);
% i=zeros(Nz,Ny)+1;
% surf(i,j,k)
% view(30,30)

% % Size of each cube
% cubeSize = [2 2 2];
% 
% % Loop through 8x8x8 grid
% for x = 1:8
%     for y = 1:8
%         for z = 1:8
%             % Position of the cube
%             pos = [x y z];
% 
%             % Color can be customized or randomized
%             color = [0.8 0.8 0.8];  % light gray
%             alpha = 0.5;            % transparency
% 
%             % Call your plotcube function
%             plotcube(cubeSize, pos, alpha, color);
% 
%         end
%     end
% end
