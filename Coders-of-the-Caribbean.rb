STDOUT.sync = true 
# game loop
x = 0; y = 0; b = !1; db = []
Sheep =  Struct.new(:id, :type, :x, :y, :rot, :speed, :rum, :owner, :x1, :y1, :z1) # :-)
Barrel = Struct.new(:id, :type, :x, :y, :rum,                       :x1, :y1, :z1)
Shit =   Struct.new(:id, :type, :x, :y, :eId, :step,                :x1, :y1, :z1) # :-)
Mine =   Struct.new(:id, :type, :x, :y,                             :x1, :y1, :z1)
def dist (a,b)
    ((a.x1-b.x1).abs + (a.y1-b.y1).abs + (a.z1-b.z1).abs)/2
end
def to_3d(x,y)
    x1 = x - (y & 0xFE) / 2 # - (y & 1)
    [x1,-x1-y,y]
end
dist2=->(a,b){Math.sqrt((a.x-b.x)**2+(a.y-b.y)**2).round}
stx=->px{[[0,px].max,22].min}
sty=->py{[[0,py].max,20].min}
dir = [ [[1, 0], [1, -1], [0, -1], [-1, 0], [0, 1], [1, 1]],
      [[1, 0], [0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1]] ]
dir12 = dir.transpose.map{|a| a.transpose.map{|x| x.reduce :+}}
STDERR.puts dir12.to_s
loop do
    my = []; op = []; bar = []; shit = []; mine = []; b = !b
    my_count = gets.to_i # the number of remaining ships
    e_count = gets.to_i # the number of entities (e.g. ships, mines or cannonballs)
    e_count.times do |i|
        a = gets.split.map{|x| Integer(x) rescue x} # id, type, x, y, arg_1, arg_2, arg_3, arg_4
        # STDERR.puts a.to_s
        case a[1]
        when "SHIP" then ((a[7] == 1)? my : op) << Sheep.new(*(a+to_3d(*a[2..3]))) 
        when "BARREL" then bar << Barrel.new(*(a[0..-4]+to_3d(*a[2..3])))
        when "CANNONBALL" then shit << Shit.new(*(a[0..-3]+to_3d(*a[2..3])))
        when "MINE" then mine << Mine.new(*(a[0..3]+to_3d(*a[2..3]))) if !db.include?(a[0]) 
        end
    end
    # STDERR.puts bar.map{|m|m.to_a[2..-1].to_s}
    my.each do |m0|
        ( x=rand(1...20); y=rand(1...20) ) if b
        xy = bar.min_by{|m| dist(m,m0)}
        o = op.min_by{|m|dist(m,m0)} # STDERR.puts "#{m0.id} #{m.id} #{dist(m,m0)}";
        bb = bar.min_by{|m|dist(m,o)}
        (x=xy.x;y=xy.y) if xy #go to bar
        b0 = mine.min_by{|m| dist(m,m0)} if mine[0] # b0 - nearest mine
        if b0 && dist(b0,m0)<2 then
            puts "FIRE #{b0.x} #{b0.y}"
            db << b0.id # destroed bombs
        elsif dist(o,m0)<6 && b then
            d1 = dir[o.y % 2][o.rot]
            d2 = dir12[o.rot]
            ls = dist2[o,m0]*o.speed/2
            dlx,dly = [ls/2 * d2[0] + ls%2 * d1[0], ls/2 * d2[1] + ls%2 * d1[1]]
            STDERR.puts ([:o_xy,o.x,o.y,dlx,dly]).to_s
            puts "FIRE #{stx[o.x+dlx]} #{sty[o.y+dly]}"
        else puts "MOVE #{x} #{y}\n"
        end
        
    end
end
