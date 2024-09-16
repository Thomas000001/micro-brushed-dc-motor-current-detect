clear all;

% 创建串口对象，用于电流数据的Arduino
arduino_current = serialport("COM5", 115200);
configureTerminator(arduino_current, "LF");  % 确保使用换行符作为终止符
arduino_current.InputBufferSize = 65536;     % 增大输入缓冲区大小

% 创建串口对象，用于磁力计数据的Arduino
arduino_imu = serialport("COM3", 115200);
configureTerminator(arduino_imu, "LF");      % 确保使用换行符作为终止符
arduino_imu.InputBufferSize = 65536;         % 增大输入缓冲区大小

% 初始化存储数据的数组
timeValues_current = [];
currentValues = [];

timeValues_mag = [];
magValues = [];

% 实时数据绘图初始化
figure;
subplot(2,1,1);
hLineCurrent = animatedline;
axCurrent = gca;
axCurrent.YGrid = 'on';
ylabel('Current (mA)');
xlabel('Time (ms)');
title('Current Data');

subplot(2,1,2);
hLineMag = animatedline;
axMag = gca;
axMag.YGrid = 'on';
ylabel('µTesla');
xlabel('Time (seconds)');
title('Magnetometer axis-y');

startTime = datetime('now');

keepRunning = true;

try
    while keepRunning
        % 检查并读取电流数据
        if arduino_current.NumBytesAvailable > 0
            data_current = char(fgets(arduino_current));  % 使用 fgets 读取一行数据

            % 解析电流数据
            currentIdx = strfind(data_current, 'C:');
            if ~isempty(currentIdx)
                current = str2double(data_current(currentIdx + 2:end));
                xDataTime_current = seconds(datetime('now') - startTime);
                
                if ~isnan(current)
                    addpoints(hLineCurrent, xDataTime_current, current);
                    axCurrent.XLim = [(xDataTime_current - 10) xDataTime_current];
                    drawnow limitrate;  % 限制绘图更新速率
                    
                    timeValues_current = [timeValues_current; xDataTime_current];
                    currentValues = [currentValues; current];
                end
            end
        end

        % 检查并读取磁力计数据
        if arduino_imu.NumBytesAvailable > 0
            data_mag = str2double(readline(arduino_imu));
            xDataTime_mag = seconds(datetime('now') - startTime);
            
            if ~isnan(data_mag)
                addpoints(hLineMag, xDataTime_mag, data_mag);
                axMag.XLim = [(xDataTime_mag - 10) xDataTime_mag];
                drawnow limitrate;  % 限制绘图更新速率
                
                timeValues_mag = [timeValues_mag; xDataTime_mag];
                magValues = [magValues; data_mag];
            end
        end
        
        % 设置退出条件，例如按键退出
        if ~ishandle(hLineCurrent) || ~ishandle(hLineMag)
            keepRunning = false;
        end
    end
catch ME
    disp('发生错误：');
    disp(ME.message);
end

% 清理工作
delete(arduino_current);
delete(arduino_imu);
clear arduino_current arduino_imu;

% 绘制采集到的数据
figure;
subplot(2,1,1);
plot(timeValues_current, currentValues);
xlabel('Time (ms)');
ylabel('Current (mA)');
title('Recorded Current Data');

subplot(2,1,2);
plot(timeValues_mag, magValues);
xlabel('Time (seconds)');
ylabel('µTesla');
title('Recorded Magnetometer axis-y Data');
