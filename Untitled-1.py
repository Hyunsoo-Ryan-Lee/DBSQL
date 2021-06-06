
import math
from collections import deque
def solution(pr, sp):
    rem = [math.ceil((100-pr[i])/sp[i]) for i in range(len(pr))]
    ans = []
    while rem: #[5, 10, 1, 1, 20, 1]
        count = 1
        cut = rem.pop(0)
        while rem and cut >= rem[0]:
            count += 1
            rem.pop(0)
        ans.append(count) 
    return ans
            
        


pr = [95, 90, 99, 99, 80, 99]	
sp = [1, 1, 1, 1, 1, 1]



def solutions(bl,w,tw):
     


