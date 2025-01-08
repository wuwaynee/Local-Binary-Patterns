import numpy as np
import cv2

# 打開txt檔,後續將把rgb各4bits的data存入此txt
data=open("data.txt",'w+') 
  
# 讀取圖檔
# img_org = cv2.imread('labi.jpg')
gray = cv2.imread('spo400x300.jpg', cv2.IMREAD_GRAYSCALE)
img_org = cv2.merge([gray, gray, gray]) # gray -> rgb (gray, gray, gray)
h, w = img_org.shape[:2]

img = img_org.copy()
img[1::2, :, :] = 0
rgb_12_bit = 0 # combine r (4bit), g (4bit), b (4bit) to 1 variable (12bit)
col_count = 0 # count for elm of col
for i in range (h):
    for j in range (w):
        col_count += 1
        
        # r, g, b 8bit->4bit
        r_4_bit = img[i, j, 0]>>4 
        g_4_bit = img[i, j, 1]>>4
        b_4_bit = img[i, j, 2]>>4
        
        # combine
        rgb_12_bit = (r_4_bit << 8) + (g_4_bit << 4) + b_4_bit
        
        # write
        if rgb_12_bit < 16:
            print('0x0'+str(hex(rgb_12_bit)[2]), end=',', file=data)
        else:
            print(hex(rgb_12_bit), end=',', file=data)
        
        # newline
        if col_count % 16 == 0:
            print(file=data)
        
data.close()