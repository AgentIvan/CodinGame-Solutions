gets
gets.split.min_by{|x|(x.to_i-0.1).abs}.to_i

# p -173
"""
N   Res  Count Temperatures
                 012345678901234567890
1   -1      5   '7_5_9_-1_4'
2   -173    1   '-173'!        
3   1       2   '-1_1'!           
4   7       5   'xx_7_9_14_12'
5   7       6   'xx_-7_10_8_7_xx'
6   7       6   'xx_7_9_14_-7_xx'
7   -8      2   '-8_-8'!           
8   0       0   ''!                      
9   7       5   '7_xx_9_14_12'
10  2       5   '7_15_x_xx_x'
11  8       2   '-8_8'!              
12  -2      10  '-8_xx_x_xx_x_-x_-x_x_-x_xx'
"""
