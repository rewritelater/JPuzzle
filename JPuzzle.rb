# we use n x m field n columns, m rows

# This is how every puzzle looks like. Every row and column has a numbers of natural numbers:
puzzle0 = {
    n:20,
    m:30,
    cols:[[2,5],[14,1,1,2],[8,1,4,3],[6,1,2,4,1],[2,2,3,2,1,3,5],[4,1,5,3,3,1,3],[3,2,1,1,3,5],[1,2,2,2,6,1,1],[1,2,1,1,1,1,2,1],[1,2,1,1,3,2,5],[1,2,1,1,1,2,1,3],[1,2,2,1,6,5],[1,6,1,1,2,1,1],[3,1,1,3],[2,1,2],[1,2,2],[1,3],[1,11],[2],[1]],
    rows:[[3],[5],[5],[3,2],[10,1],[6,2],[3,1,1],[2,1,1,1,1,1,1,1],[1,8,1],[1,4,1,1,1,1],[1,1,1,1],[1,2,1,1,1],[1,1,4,1,1],[3,1,2,2],[1,3,2,1,2],[2,2,3,5],[1,2,5,2],[4,1,2],[1,1,3,5],[1,4,1,1],[2,3,1],[5,1],[10],[12],[2,2],[14],[1,1,1,1],[3,3],[3,3],[4,4]]
}


puzzle1 = {
    n:15,
    m:15,
    cols:[[2,1,1,2],[1,1,1,1,1],[2,1,1,1,4],[1,1,4],[2,1,6],[1,1,1,1,3],[1,3,2],[1,1,4],[1,9],[5],[1,5],[8],[1,2],[1,1],[2]],
    rows:[[6,1,1],[1,1,1,1,1],[1,1,1,1],[1,1,1],[1,1],[1,1],[3],[7],[7,1],[3,7,1],[1,3,8],[1,5,1,1],[7,1,1],[1,1,1,1],[1,1,1,1]]
}
puzzle2 = {
    n:15,
    m:15,
    cols:[[5],[3,3],[2,2],[1,2],[1,3,1],[1,5,2],[1,6,2,1],[3,3,2,1],[3,3,2],[8,2],[8,2],[13],[11],[9],[5]],
    rows:[[5],[2,5],[1,8],[2,3,5],[1,3,5],[2,11],[1,10],[1,9],[1,5],[2,4],[1,2,3],[2,2,3],[2,3],[3,4],[5]]
}
def printcell(cell)
    if cell == :filled
        print "■" # ASCII code 219. There used to be "x" here
    elsif cell == :empty
        print "_"
    elsif cell == :differs
        print "d"
    elsif cell == nil
        print " "
    else 
        print "e"
    end
end

def magic_formula(znumbers)
    znumbers.length + znumbers.sum - 1
end

class JPuzzle
    def initialize(args)
        # Fill all cells with nils
        @m = args[:m]
        @n = args[:n]
        @cells = Array.new(@m)  
        for i in (0...@m) do
            @cells[i] = Array.new(@n)
        end

        # Order of solving the puzzle line by line
        @linesQueue = LinesList.new(@m+@n) 
        
        load_lines(args[:cols],args[:rows])

    end

    def load_lines(cols, rows) # converts given array of numbers into linked list
        cols.each_with_index do |x,i|
            newline = Line.new i, :column, x
            @linesQueue.insert newline
        end
        
        rows.each_with_index do |x,i|
            newline = Line.new i, :row, x
            @linesQueue.insert newline
        end

    end
    def read_cells(type, index) # reads row or column from @cells; returns 1D array
        line = Array.new
        if type == :row 
            begin
                i,j = index,0
                begin
                    line = line << @cells[i][j] 
                    j+=1
                end until j==@n
            end
        elsif type == :column 
            begin
                i,j = 0,index
                begin
                    line = line << @cells[i][j] 
                    i+=1
                end  until i==@m
            end
        else
            raise "line type error"
        end
        line
    end
    def find_variants(line, numbers, index=0)
        i = index
        max = line.length - 1
        return [] if i > max 
        debug = false
        print "", ""*i, "" if debug
        print "$" if debug
        show_line line    if debug     
        variants = Array.new # default result will be empty array

        if line[i] == :filled
           # puts "filled"
            if(a = numbers.shift)
                while a > 0 do
                    if (i > max )||(line[i] == :empty)
                        puts "no 90"  if debug# tried to fill but met empty
                        return []
                    end
                    line[i] = :filled
                    i += 1
                    a -= 1
                end
                if (i >= max) && (numbers.empty?)
                    if line[i]==:filled
                        puts "no 99" if debug
                        return []
                    end
                    line[i] = :empty if i==max
                    puts "yes 103: #{(i == max)}" if debug
                    return [line]
                elsif (i >= max) && (!numbers.empty?)
                    puts "no 106" if debug
                    return []
                else
                    if line[i]==:filled
                        puts "no 110" if debug
                        return []
                    end
                    line[i] = :empty
                    
                    #variants.push *find_variants(line, numbers, i)
                    
                    puts "idk 117"  if debug# filled number in, check further
                    return find_variants(line.dup, numbers.dup, i)
                end
            else
                puts "no 121" if debug # X, but no number
                return []
            end
        elsif line[i] == :empty
           # puts "empty"
            if (numbers.sum)>(max-i)
                puts "no 127" if debug
                return []
            end
            if numbers.empty?
               # puts "numbers empty"
                while i<=max do

                    if line[i] == :filled
                        puts "no 135" if debug
                        return [] 
                    end

                    line[i] = :empty
                    i+=1
                end
                #variants.push line
                puts "yes 143" if debug
                return [line]

            else
                #variants.push *find_variants(line, numbers, i+1)
                puts "idk 148" if debug
                
                
                return find_variants(line.dup, numbers.dup, i+1)
            end

        elsif line[i] == nil
            # forking...
            puts "forking..." if debug
            line2 = line.dup
            numbers2 = numbers.dup
            line3 = line.dup
            numbers3 = numbers.dup

            line3[i] = :filled
            var3 = find_variants(line3, numbers3, i)
            variants.push(*var3)

            line2[i] = :empty
            var2 = find_variants(line2, numbers2, i)
            variants.push(*var2)

            #puts variants.length
        else
            puts "error 172"
        end

        variants
    end
    def test
        #puts @linesQueue.class
        #@linesQueue.debug_print
        1.times do # doesn't work 5 times
            queue = @linesQueue.dup

            while curLine = queue.shift do #TODO: replace 

                # 1. read current line from cells into 1D array
                
                field = read_cells(curLine.type,curLine.index)
                #field = Array.new(9)
                fl = field.length

                #print field
                #field[5] = :filled
                #puts "Given line:"
                #show_line field
                
                #puts "Given set:"
                numbers = curLine.numbers
                #numbers = [5]
                print curLine.type, " #", curLine.index
                print numbers, "\n"
                # 2. Find all ways to fill the line
                
                variants = find_variants(field.dup,numbers.dup)
                puts "Variants: #{variants.length}"
                #variants.each do |v|
                #    show_line v
                #end 
                # 3. Check variants for common cells
                sureThing = Array.new(fl)
                variants.each do |v|
                    i = failcounter = 0
                    while i<fl do
                        if sureThing[i] == nil
                            sureThing[i] = v[i]
                        elsif sureThing[i] == :differs
                            i+=1
                            next
                        elsif sureThing[i] != v[i]
                            sureThing[i] = :differs
                            failcounter += 1;
                        end
                        i+=1
                    end
                    break if failcounter >=fl
                end 
                print "sureThing: "
                show_line sureThing
                
                # transfer this into @cells
                cellsAffected = write_cells(curLine, sureThing)
                print "affected #{cellsAffected} cells\n"

                show_cells
                sleep 0.4
            end
        end
        #show_cells
    end
    def write_cells(curLine, sureThing)
        affected = 0
        
        if curLine.type == :row
            i,j = curLine.index,0
            while j<@n do
                    if sureThing[j]!=:differs
                        if@cells[i][j]==nil
                            @cells[i][j] = sureThing[j]
                            affected += 1
                        elsif @cells[i][j] != sureThing[j]
                            raise "panic! rewrite all program"
                        end
                    end
                j+=1
            end
        elsif curLine.type == :column
            i,j = 0,curLine.index
            while i<@m do
                if sureThing[i] != :differs
                    if @cells[i][j] == nil
                        @cells[i][j] = sureThing[i]
                        affected += 1
                    elsif @cells[i][j] != sureThing[i]
                        raise "panic! rewrite all program"
                    end
                end
                i+=1
            end

        end
        affected
    end
    def write_cells_debug(curLine, sureThing)
        affected = 0
        
        if curLine.type == :row
            i,j = curLine.index,0
            while j<@n do
                if sureThing[j] == :differs
                    # do nothing, no point
                elsif @cells[i][j] == nil
                    @cells[i][j] = sureThing[j]
                    affected += 1
                    print i," ",j,"\n"
                elsif @cells[i][j] == sureThing[j]
                    # good thing, do nothing
                elsif @cells[i][j] != sureThing[j]
                    raise "panic! rewrite all program"
                end
                j+=1
            end
        elsif curLine.type == :column
            i,j = 0,curLine.index
            while i<@m do
                if sureThing[i] == :differs
                    # do nothing, no point
                elsif @cells[i][j] == nil
                    @cells[i][j] = sureThing[i]
                    affected += 1
                elsif @cells[i][j] == sureThing[i]
                    # good thing, do nothing
                elsif @cells[i][j] != sureThing[i]
                    raise "panic! rewrite all program"
                end
                i+=1
            end

        end
        print "affected #{affected} cells\n"
        affected
    end
    def show_line(line)
        print "["
        for j in (0...line.length) do
            printcell line[j] 
            print " "
        end
        print "]\n"
    end
    def show_cells
        #puts "RESULT:"
        for i in (0...@m) do
            for j in (0...@n) do
                printcell @cells[i][j] 
                print " "
            end
            print "\n"
        end
    end
    def solved?
        solved = true
        for i in (0...@m) do
            for j in (0...@n) do
                return false if @cells[i][j] == nil
            end
        end
        solved
    end
end

# list of lines 
class LinesList
    
    def initialize(maxPriority)
        @first =  Line.new(0, :placeholder, [], maxPriority)
        
    end

    def insert newline
        cur = @first
        done = false
        while cur.next do
            if(cur.next.w < newline.w) # compare priorities
                newline.next, cur.next  = cur.next, newline
                done = true
                break
            end
            cur = cur.next
        end
        if not done 
            cur.next  = newline
        end
        
    end
    def shift
        x = @first.next
        @first.next = x.next if x # remove if exists
        return x
    end
    def empty? 
         @first.next ? false : true 
    end
    
    def debug_print
        cur = @first
        while cur do
            
            cur.debug_print
            cur = cur.next
        end
    end

end
# all rows and columns can be just lines
class Line
    def initialize(index, type, numbers, w=0)
        @index, @type  = index, type
        @numbers = numbers
        
        if w>0 
            @priority = w
        else
            @priority = magic_formula(@numbers)
        end
        @next = nil
    end
    def numbers
        @numbers
    end
    def index
        @index
    end
    def next
        @next
    end
    def next=(something)
        @next = something
    end
    def type
        @type
    end
    def priority
        @priority
    end
 
    alias w priority # like weight

    def <=>(line2) # doesnt work
        if @priority < line2.priority
            -1
        elsif @priority > line2.priority
            1
        else
            0
        end
    end
    def debug_print
        print @priority, " ", @type ,"",@index,"\n"
    end
end


puzzle = JPuzzle.new puzzle1
puzzle.test

20.times do
    puzzle.load_lines(puzzle1[:cols],puzzle1[:rows])
    puzzle.test
    break if puzzle.solved?
end