#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;
int main()
{
    while (1) {
        int x, y, dataCount, enemyCount;
        cin >> x >> y; cin.ignore();
        cin >> dataCount; cin.ignore();
        for (int i = 0; i < dataCount; i++) {
            int dataId, dataX, dataY;
            cin >> dataId >> dataX >> dataY; cin.ignore();
        }
        double dist = 99999999;
        int nId, nX, nY; // nearestId, nearestX, nearestY
        cin >> enemyCount; cin.ignore();
        for (int i = 0; i < enemyCount; i++) {
            int enemyId, enemyX, enemyY, enemyLife;
            cin >> enemyId >> enemyX >> enemyY >> enemyLife; cin.ignore();
            int dX = x-enemyX;
            int dY = y-enemyY;
            double d2 = dX*dX+dY*dY;
            if(dist > d2)
            {
                dist = d2;
                nId = enemyId;
                nX = enemyX;
                nY = enemyY;
            }
        }
        if(dist<2500*2500) cout << "MOVE  " << 2*x - (nX+x)/2 << " " << 2*y - (nY+y)/2 << endl;
        else if(dist>5000*5000) cout << "MOVE " << (nX+x)/2 << " " << (nY+y)/2 << endl;
        else cout << "SHOOT " << nId << endl; // MOVE x y or SHOOT id        
    }
}
