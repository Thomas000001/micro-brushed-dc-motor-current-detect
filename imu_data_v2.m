clear all;
arduino_imu =  serialport("COM3",115200);



% 初始化存储数据的数组
timeValues = [];
magValues = [];


% 实时数据绘图初始化
figure;
hLine = animatedline;
ax = gca;
ax.YGrid = 'on';
xlabel('Time (seconds)')
ylabel('µTesla')
title('Magnetometer axis-y')

% 记录开始时间
startTime = datetime('now');

try
    while true
        if arduino_imu.BytesAvailable > 0
            data = str2double(fgetl(arduino_imu));
            
            
            magValue_y = data;


            
            % 计算从开始到现在经过的秒数
            xDataTime = seconds(datetime('now') - startTime);
            
            
            % 更新图表的X轴和Y轴数据
            %set(hLine, 'XData', xDataTime(1:t), 'YData', magValue_z(1:t));
            
            %xlim([0 elapsedTimeSecs]); % 设置X轴的极限为当前的经过时间
            %ylim([min(magValue_z(1:t)) max(magValue_z(1:t))]); % 自动调整Y轴极限以适应数据范围
    
            if ~isnan(magValue_y)
                % 更新绘图
                addpoints(hLine, xDataTime, magValue_y);
                ax.XLim = [(xDataTime - 10) xDataTime];
                datetick('x', 'keeplimits', 'keepticks');
                drawnow;
    
                % 存储数据
                timeValues = [timeValues; xDataTime];
                magValues = [magValues; magValue_y];
                
            end
        end        
    end
catch ME
    disp(['Error: ', ME.message]);
    %fclose(arduino_imu);
    plot(timeValues, magValues)
    xlabel('time(s)')
    ylabel('axis-y(µT)')
    delete(arduino_imu);
    clear arduino_imu;
end