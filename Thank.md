using System;
using System.Linq;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
class Player
{
    public class Point
    {
        public int Id { get; set; }
        public int X { get; set; }
        public int Y { get; set; }
        public int Dist2(Point p)
        {
            return (int)Math.Round(Math.Pow(p.X-X,2)+Math.Pow(p.Y-Y,2));
        }
        public int Dist2(int x, int y)
        {
            return (int)Math.Round(Math.Pow(x-X,2)+Math.Pow(y-Y,2));
        }
        public override string ToString()
        {
            return $"{Id} {X}:{Y}";
        }
    }
    public class DPoint : Point
    {
    }
    public class Enemy : Point
    {
        public int Life { get; set; }
        public DPoint NearDp { get; set; }
        public int NearDpDist { get; set; }
        public int MeDistPow { get; set; }
        public double Shoot { get; set; }
        public Point Next
        {
            get
            {
                int nextX = NearDpDist != 0 ? X+(NearDp.X-X)*500/NearDpDist : X;
                int nextY = NearDpDist != 0 ? Y+(NearDp.Y-Y)*500/NearDpDist : Y;
                Point p = new Point
                {
                    Id = this.Id,
                    X = nextX,
                    Y = nextY
                };
                return p;
            }
        }
    }
    static void Main(string[] args)
    {
        string[] inputs;
        DPoint[] dP;
        Enemy[] ee;

        // game loop
        while (true)
        {
            inputs = Console.ReadLine().Split(' ');
            int meX = int.Parse(inputs[0]);
            int meY = int.Parse(inputs[1]);
            Point me = new Point
            {
                Id = -1,
                X = meX,
                Y = meY
            };
            int dataCount = int.Parse(Console.ReadLine());
            dP = new DPoint[dataCount];
            for (int i = 0; i < dataCount; i++)
            {
                var input = Console.ReadLine();
                inputs = input.Split(' ');
                int dataId = int.Parse(inputs[0]);
                int dataX = int.Parse(inputs[1]);
                int dataY = int.Parse(inputs[2]);
                dP[i] = new DPoint
                {
                    Id = dataId,
                    X = dataX,
                    Y = dataY
                };
            }
            int enemyCount = int.Parse(Console.ReadLine());
            ee = new Enemy[enemyCount];
            for (int i = 0; i < enemyCount; i++)
            {
                var input = Console.ReadLine();
                inputs = input.Split(' ');
                int enemyId = int.Parse(inputs[0]);
                int enemyX = int.Parse(inputs[1]);
                int enemyY = int.Parse(inputs[2]);
                int enemyLife = int.Parse(inputs[3]);
                DPoint enemyNearDp = dP.Aggregate((a,b) => a.Dist2(enemyX, enemyY) < b.Dist2(enemyX, enemyY) ? a : b);
                int enemyNearDpDist = (int)Math.Round(Math.Sqrt(enemyNearDp.Dist2(enemyX, enemyY)));
                int enemyMeDistPow = me.Dist2(enemyX, enemyY);
                double enemyShoot = 125000 / Math.Pow(enemyMeDistPow, 0.6);
                Console.Error.Write("Id,X,Y,Life:{0},\tnId:{1},\tDist:{2}, Shoot:{3:0.00} ", input, enemyNearDp.Id, enemyNearDpDist, enemyShoot);
                ee[i] = new Enemy
                {
                    Id = enemyId,
                    X = enemyX,
                    Y = enemyY,
                    Life = enemyLife,
                    NearDp = enemyNearDp,
                    NearDpDist = enemyNearDpDist,
                    MeDistPow = enemyMeDistPow,
                    Shoot = enemyShoot
                };
                Console.Error.WriteLine(ee[i].Next);
            }
            List<Enemy> enemies = ee.Where(a => a.Next.Dist2(me) < 2400*2400).ToList();
            // Write an action using Console.WriteLine()
            // To debug: 
            Enemy minDistEnemy = ee.Aggregate((a,b) => a.Next.Dist2(me) < b.Next.Dist2(me) ? a : b);
            Enemy minShootEnemy = ee.Aggregate((a,b) => a.Shoot - a.Life > b.Shoot - b.Life ? a : b);
            Console.Error.WriteLine($"{minShootEnemy.Shoot}<>{minShootEnemy.Life}");
            int minDistPow = minDistEnemy.Dist2(me);
            if(minDistPow<2500*2500)
            {
                int eX=0,eY=0;
                if(enemies.Count>1)
                    {
                        foreach(Enemy e in enemies)
                        {
                            eX += e.X;
                            eY += e.Y;
                        }
                        eX /= enemies.Count;
                        eY /= enemies.Count;
                    }
                else
                {
                    eX=minDistEnemy.X;
                    eY=minDistEnemy.Y;
                }
                Console.Error.WriteLine($"e.Count:{enemies.Count}, eX:{eX}, eY:{eY}");
                Console.WriteLine($"MOVE  {2*me.X - (eX+me.X)/2} {2*me.Y - (eY+me.Y)/2}");
            }
            else if (minShootEnemy.Shoot >= minShootEnemy.Life-0.7)
                Console.WriteLine($"SHOOT {minShootEnemy.Id}");
            else if(minDistPow>4000*4000)
                Console.WriteLine($"MOVE  {(minDistEnemy.X+me.X)/2} {(minDistEnemy.Y+me.Y)/2}");
            else
                Console.WriteLine($"SHOOT {minDistEnemy.Id}");
        }
    }
}
