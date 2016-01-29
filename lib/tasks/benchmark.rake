desc 'Benchmark grabbing 100 random event reports, 100 times'
task benchmark: :environment do
  num_records = 1_294_102
  limit = 100
  runs = 3

  Benchmark.bmbm do |bm|
    bm.report('view') do
      runs.times do
        offset = rand(num_records)
        EventReport.order(:created_at).offset(offset).limit(limit).to_a
      end
    end
    bm.report('mview') do
      runs.times do
        offset = rand(num_records)
        FastEventReport.order(:created_at).offset(offset).limit(limit).to_a
      end
    end
  end
end
