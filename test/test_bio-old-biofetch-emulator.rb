require 'helper'

module FuncTestBioOldBiofetchEmulator

  module CommonTestMethods

    def fetch_and_check_ids(db, ids, regexp)
      tmp_ids = ids.dup
      str = @bf.fetch(db, ids.join(","))
      str.scan(regexp) do |x|
        assert_equal(tmp_ids.shift.to_s, $1)
      end
      assert(tmp_ids.empty?)

      str2 = @bf.fetch(db, ids.join(" "))
      assert_equal(str, str2)
    end
    private :fetch_and_check_ids

    def test_fetch_pubmed
      db = "pubmed"
      ids = [ 20739307, 22332238 ]
      regexp = /^PMID- +(\d+)/
      fetch_and_check_ids(db, ids, regexp)
    end

    def test_fetch_refseq
      db = "rs"
      ids = [ "NM_123456", "NP_198907" ]
      regexp = /^ACCESSION +([\_A-Z0-9]+)/
      fetch_and_check_ids(db, ids, regexp)
    end

    def test_fetch_kegg_genes
      db = "hal"
      ids = [ "VNG1467G", "VNG6476G", "VNG2243G" ]
      regexp = /^ENTRY +([A-Z0-9]+)/
      fetch_and_check_ids(db, ids, regexp)
    end

    def test_fetch_aaindex
      db = "aax"
      ids = [ "PRAM900102", "DAYM780301" ] # (aaindex1, aaindex2)
      regexp = /^H +([A-Z0-9]+)$/
      fetch_and_check_ids(db, ids, regexp)
    end

    def test_class
      assert_instance_of(Bio::OldBioFetchEmulator::Client, @bf)
      assert_equal(Bio::OldBioFetchEmulator::Client, @bf.class)
    end
  end #module CommonTestMethods

  class TestClient < Test::Unit::TestCase
    include CommonTestMethods

    def setup
      Bio::NCBI.default_email ||= "staff@bioruby.org"
      @bf = Bio::OldBioFetchEmulator::Client.new
    end
  end #class TestClient

  class TestBioFetch < Test::Unit::TestCase
    include CommonTestMethods

    def setup
      Bio::NCBI.default_email ||= "staff@bioruby.org"
      @bf = Bio::Fetch.new
    end

  end #class TestClient

  class TestBioFetchWithURL < Test::Unit::TestCase
    include CommonTestMethods

    def setup
      Bio::NCBI.default_email ||= "staff@bioruby.org"
      @bf = Bio::Fetch.new("http://bioruby.org/cgi-bin/biofetch.rb")
    end

  end #class TestClient

  class TestBioFetchWithOtherURL < Test::Unit::TestCase
    def setup
      Bio::NCBI.default_email ||= "staff@bioruby.org"
      @bf = Bio::Fetch.new("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch")
    end

    def test_class
      assert_instance_of(Bio::Fetch, @bf)
      assert_equal(Bio::Fetch, @bf.class)
    end
  end #class TestClient

end #module FuncTestBioOldBiofetchEmulator

