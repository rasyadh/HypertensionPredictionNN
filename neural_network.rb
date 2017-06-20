require 'csv'
$dataset, $w, $samples = [], [], []
$bias, $threshold, $miu = 1, 0, 0.3

def readFile(namaFile)
    data = []
    CSV.foreach(namaFile) do |row|
        $kolom = row.count
        $kolom.times { |i|  
            data[i] = row[i].to_i
        }
        $dataset.push(data)
        data = []
    end
end

def inputTarget
    for i in 0...$dataset.length
        for j in 0...$kolom
            if (j < $kolom - 1)
                $input_sequence[i][j] = $dataset[i][j]
            else
                $target_sequence[i] = $dataset[i][j]
            end
        end
    end
end

def randomW
    puts "Random nilai w : "
    for i in 0...$kolom
        $w[i] = rand(-1.0 .. 1.0).round(1)
        print "w#{i} : #{$w[i]}"
        puts
    end
    puts
end

def calcNN
    $iterasi = 0
    begin
        $indeks = $iterasi + 1
        $baris, $hasil, $benar = 0, 0.0, 0
        puts "Iterasi ke-#{$indeks}"
        begin
            $hasil = 0
            puts "Data ke-#{$baris}"
            for i in 0...$kolom -1
                $hasil = $hasil + ($input_sequence[$baris][i].to_f * $w[i])
            end
            $hasil = $hasil + $bias * $w[-1]
            puts "Perhitungan\t\t: #{$hasil.round(1)}"

            if ($hasil < $threshold)
                $output = 0
            else
                $output = 1
            end
            puts "Hasil Threshold\t: #{$output}"
            $err = $target_sequence[$baris] - $output
            puts "Error\t\t\t: #{$err}"

            if($err != 0)
                puts "", "Nilai W baru : "
                for x in 0...$kolom
                    if (x != $kolom -1)
                        $w[x] = $w[x] + $miu * $input_sequence[$baris][x] * $err
                    else
                        $w[x] = $w[x] + $miu * $bias * $err
                    end
                    puts "w#{x} : #{$w[x].round(1)}"
                end
                puts
                $benar = 0
            else
                $benar = $benar + 1
            end
            $baris = $baris + 1
        end while($baris < $input_sequence.length)
        $iterasi = $iterasi + 1
        puts
    end while($iterasi < 100 && $benar!= $input_sequence.length)

    puts "Total iterasi : #{$iterasi}", "Hasil w : "
    $kolom.times { |i|
        puts "w#{i} : #{$w[i].round(1)}"
    }
    puts
end

def cetakData
    puts "Data Hipertensi"
    print "Umur\tKegemukan\tHipertensi\n"
    for i in 0...$dataset.length
        for j in 0...$kolom
            print "#{$dataset[i][j]}\t\t\t"
        end
        puts
    end
    puts
    puts "Threshold : #{$threshold}"
    puts
end

def predict
    $prediksi = 0
    for i in 0...$kolom -1
        $prediksi += $samples[i] * $w[i]
    end
    $prediksi = $prediksi + $bias * $w[-1]
    puts "Jika umur : #{$samples[0].to_i} dan kegemukan : #{$samples[1].to_i}"
    puts "Perhitungan\t: #{$prediksi.round(1)}"
    if ($prediksi < $threshold)
        $outpredik = 0
    else
        $outpredik = 1
    end
    
    if ($outpredik == 0)
        puts "Hipertensi\t: tidak"
    else
        puts "Hipertensi\t: ya"
    end
end

readFile("data_hipertensi.csv")
puts "Algoritma Neural Network"
$input_sequence = Array.new($dataset.length){Array.new($kolom)}
$target_sequence = []
print "Masukkan data umur : "
$samples[0] = gets.chomp.to_f
print "Masukkan data kegemukan : "
$samples[1] = gets.chomp.to_f
$stdout = File.new("hasil_hipertensi.txt", "w")
puts "Algoritma Neural Network"
cetakData
inputTarget
randomW
calcNN
predict
$stdout.sync = true