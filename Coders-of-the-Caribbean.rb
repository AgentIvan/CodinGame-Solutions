STDOUT.sync = true 
# game loop
x = 0; y = 0; b = !1
Sheep =  Struct.new(:id, :type, :x, :y, :rot, :speed, :rum, :owner)
Barrel = Struct.new(:id, :type, :x, :y, :rum, :a2,    :a3,  :a4)
def dist (a,b)
    ax = a.x - (a.y - (a.y & 1)) / 2
    bx = b.x - (b.y - (b.y & 1)) / 2
    ((ax-bx).abs + (ax+a.y-bx-b.y).abs + (a.y-b.y).abs)/2
end
loop do
    my = []; op = []; bar = []; ball = []; mine = []
    my_count = gets.to_i # the number of remaining ships
    e_count = gets.to_i # the number of entities (e.g. ships, mines or cannonballs)
    e_count.times do |i|
        a = gets.split.map{|x| Integer(x) rescue x} # id, type, x, y, arg_1, arg_2, arg_3, arg_4
        # STDERR.puts a.to_s
        case a[1]
        when "SHIP" then ((a[7] == 1)? my : op) << Sheep.new(*a) 
        when "BARREL" then bar << Barrel.new(*a)
        end
    end
    my.each do |m0|
        (x=rand(1...20); y=rand(1...20)) if b=!b
        xy = bar.min_by{|m| dist(m,m0)}
        o = op.min_by{|m|STDERR.puts "#{m0.id} #{m.id} #{dist(m,m0)}";dist(m,m0)}
        (x=xy.x;y=xy.y) if xy #go to barrrel
        if dist(o,m0)<6 then puts "FIRE #{o.x} #{o.y}"
        else puts "MOVE #{x} #{y}\n"
        end
    end
end
