desc 'Benchmark grabbing random event reports from view and mview'
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
