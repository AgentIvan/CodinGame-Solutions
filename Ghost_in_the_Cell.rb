STDOUT.sync = true # DO NOT REMOVE

@factory_count = gets.to_i # the number of factories
@link_count = gets.to_i # the number of links between factories
Link = Struct.new(:id1, :id2, :dist)
links = []
@link_count.times do |i|
    a = gets.split.map &:to_i
    STDERR.puts $_
    links[i] = Link.new(a[0], a[1], a[2])
end
b = 0
Entity = Struct.new(:id, :type, :arg_1, :arg_2, :arg_3, :arg_4, :arg_5)
# game loop
loop do
    entity_count = gets.to_i # the number of entities (e.g. factories and troops)
    entities = []

    entity_count.times do|i|
        a = gets.split.map{|x| Integer(x) rescue x}
        STDERR.puts $_
        if (a[1] == "FACTORY")
            entities[i] = Entity.new(*a) # the same as: a[0], a[1], a[2], a[3], a[4], a[5], a[6]
        elsif (a[1] == "TROOP")
            e = entities.select{|e|e.id==a[4]}[0]
            e.arg_2+=(e.arg_1==a[2])? a[5]: -a[5] if a[6]<1
            STDERR.puts [e]*""
        end
    end
    
    my = entities.select{|e|e.arg_1==1}.sort_by{|e| -e.arg_2}
    op = entities.select{|e|e.arg_1==0&&e.arg_3>0}.sort_by{|e| [-e.arg_3, e.arg_2]}
    # op = entities.select{|e|e.arg_1==0}.sort_by{|e| -e.arg_2} if !op[0]
    op = entities.select{|e|e.arg_1==-1&&e.arg_3>0&&e.arg_2>0}.sort_by{|e| [e.arg_3,e.arg_2]} if !op[0]
    op = entities.select{|e|e.arg_1==-1}.sort_by{|e| -e.arg_2} if !op[0]
    # Any valid action, such as "WAIT" or "MOVE source destination cyborgs"
    out = ["WAIT"]
    if b<2
        b += 1
        out << "BOMB #{my[0].id} #{entities.select{|e|e.arg_1==-1}[0].id}"
    elsif b<3
        b += 1
        out << "MOVE #{my[0].id} #{entities.select{|e|e.arg_1==-1}[0].id} 2"
        my.sort_by!{|e| -e.arg_2}
    end
    my.each{|m|
        STDERR.puts ["m:", m]*" "
        op.each{|o|
            STDERR.puts ["o:", o]*" "
            if (o && m)
                if 1 < kib_count = [[m.arg_2-2,0].max, o.arg_2+1].min
                    out << "MOVE #{m.id} #{o.id} #{kib_count}"
                end
            end
        }
    }
    puts out*?;
end
