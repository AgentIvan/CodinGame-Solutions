#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

/**
 * Shoot enemies before they collect all the incriminating data!
 * The closer you are to an enemy, the more damage you do but don't get too close or you'll get killed.
 **/
int main()
{

    // game loop
    while (1) {
        int x;
        int y;
        cin >> x >> y; cin.ignore();
        int dataCount;
        cin >> dataCount; cin.ignore();
        for (int i = 0; i < dataCount; i++) {
            int dataId;
            int dataX;
            int dataY;
            cin >> dataId >> dataX >> dataY; cin.ignore();
        }
        int enemyCount;
        double dist = 99999;
        int nId; // nearestId
        int nX;  // nearestX
        int nY;  // nearestY
        cin >> enemyCount; cin.ignore();
        for (int i = 0; i < enemyCount; i++) {
            int enemyId;
            int enemyX;
            int enemyY;
            int enemyLife;
            cin >> enemyId >> enemyX >> enemyY >> enemyLife; cin.ignore();
            int distX = x-enemyX;
            int distY = y-enemyY;
            if(dist*dist > distX*distX+distY*distY)
            {
                dist = sqrt(distX*distX+distY*distY);
                nId = enemyId;
                nX = enemyX;
                nY = enemyY;
            }
        }

        // Write an action using cout. DON'T FORGET THE "<< endl"
        // To debug: cerr << "Debug messages..." << endl;
        cerr << dist << endl;
        // x=(a+b)/2
        // 2*x2=a2+b2 // x2=b, a2=x
        // b2=2*x2-a2
        // b2=2*b-(a+b)/2= 1.5*b-a/2
        if(dist<2500)
            cout << "MOVE  " << 2*x - (nX+x)/2
             << " " << 2*y - (nY+y)/2 << endl; // MOVE x y or SHOOT id
        else 
        if(dist>5000)
            cout << "MOVE " << (nX+x)/2 << " " << (nY+y)/2 << endl;
        else
            cout << "SHOOT " << nId << endl; // MOVE x y or SHOOT id
        
    }
}
