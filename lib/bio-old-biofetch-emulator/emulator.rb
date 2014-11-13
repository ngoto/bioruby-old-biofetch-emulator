
require 'bio'
require 'cgi'

module Bio

  module OldBioFetchEmulator

    URL = "http://bioruby.org/cgi-bin/biofetch.rb".freeze

    MAX_ID_NUM = 50

    class Client < Bio::Fetch

      # https://web.archive.org/web/20070803003306/http://www.genome.jp/about_genomenet/service.html
      # https://web.archive.org/web/20110525080429/http://www.genome.jp/dbget/

      # https://web.archive.org/web/20070306215757/http://bioruby.org/cgi-bin/biofetch.rb?info=dbs
      # aa aax bl cpd dgenes dr ec eg emb embu epd est exp
      # gb gbu genes gl gn gp gpu gss htgs ko ld lit mim nt
      # og path pd pdb pdoc pf pir pmd pr prf ps rn rp rs
      # rsaa rsnt sp str sts tr vg

      Databases = {
        # fetching via Bio::PubMed (NCBI E-Utilities)
        "pubmed"  => [ :PubMed, true ],

        # fetching via TogoWS REST API
        "genbank"    => [ :TogoWS, "ncbi-nucleotide" ],
        "gb"         => "genbank",

        "genpept"    => [ :TogoWS, "ncbi-protein" ],
        "gp"         => "genpept",

        "refseq"     => [ :TogoWS, "ncbi-nucleotide", "ncbi-protein" ],
        "rs"         => "refseq",
        "refnuc"     => [ :TogoWS, "ncbi-nucleotide" ], 
        "rsnt"       => "refnuc",
        "refpep"     => [ :TogoWS, "ncbi-protein" ],
        "rsaa"       => "refpep",

        "embl"       => [ :TogoWS, "ebi-ena" ],
        "emb"        => "embl",

        "uniprot"    => [ :TogoWS, true ],
        "up"         => "uniprot",
        "swissprot"  => "uniprot",
        "sp"         => "uniprot",
        "trembl"     => "uniprot",
        "tr"         => "uniprot",

        "pdb"        => [ :TogoWS, true ],

        #"genes"      => [ :TogoWS, "kegg-genes" ],

        # fetching via KEGG REST API
        "pathway"    => [ :KEGG, true ],
        "path"       => "pathway",
        "brite"      => [ :KEGG, true ],
        "br"         => "brite",
        "module"     => [ :KEGG, true ],
        "md"         => "module",
        "orthology"  => [ :KEGG, true ],
        "ko"         => "orthology",
        "genome"     => [ :KEGG, true ],
        "genomes"    => [ :KEGG, true ],
        "gn"         => "genomes",
        "genes"      => [ :KEGG, true ],
        "ligand"     => [ :KEGG, true ],
        "compound"   => [ :KEGG, true ],
        "cpd"        => "compound",
        "glycan"     => [ :KEGG, true ],
        "gl"         => "glycan",
        "reaction"   => [ :KEGG, true ],
        "rn"         => "reaction",
        "rpair"      => [ :KEGG, true ],
        "rp"         => "rpair",
        "rclass"     => [ :KEGG, true ],
        "rc"         => "rclass",
        "enzyme"     => [ :KEGG, true ],
        "ec"         => "enzyme",
        "disease"    => [ :KEGG, true ],
        "ds"         => "disease",
        "drug"       => [ :KEGG, true ],
        "dr"         => "drug",
        "dgroup"     => [ :KEGG, true ],
        "dg"         => "dgroup",
        "environ"    => [ :KEGG, true ],
        "ev"         => "environ",

        "expression" => [ nil ], #[ :KEGG, true ],
        "ex"         => "expression",
        "exp"        => "expression",

        "dgenes"     => [ :KEGG, true ],
        "egenes"     => [ :KEGG, true ],
        "eg"         => "egenes",
        "mgenes"     => [ nil ], #[ :KEGG, true ],
        "mgenome"    => [ nil ], #[ :KEGG, true ],
        "mgnm"       => "mgenome",

        "vgenome"    => [ :KEGG, true ],
        "vgnm"       => "vgenome",
        "vgenes"     => [ :KEGG, true ],
        "vg"         => "vgenes",

        # fetching from GenemeNet
        "aaindex"  => [ :DBGET, true ],
        "aax"      => "aaindex",
        "aaindex1" => [ :DBGET, true ],
        "aax1"     => "aaindex1",
        "aaindex2" => [ :DBGET, true ],
        "aax2"     => "aaindex2",
        "aaindex3" => [ :DBGET, true ],
        "aax3"     => "aaindex3",

        # formerly can be get from GenomeNet but not available now
        "prf"        => [ nil ], #[ :DBGET, true ],
        "litdb"      => [ nil ], #[ :DBGET, true ],
        "lit"        => [ nil ], #"litdb",

        "pdbstr"  => [ nil ], # Protein sequence generated from PDB (GenomeNet)

        "aa"      => [ nil ], # nr-aa ???
        #"aax" # AAindex (KEGG)
        "bl"      => [ nil ], # Blocks (http://blocks.fhcrc.org/)
        #"cpd" # KEGG Compound
        #"dgenes" # KEGG DGenes
        #"dr" # KEGG Drug
        #"ec" # KEGG Enzyme
        #"eg" # KEGG EGenes
        #"emb" # EMBL
        "embu"    => [ nil ], # EMBL UniGene ???
        "epd"     => [ nil ], # The Eukaryotic Promoter Database
        "est"     => [ nil ], # NCBI EST ???
        #"gb" # GenBank
        "gbu"     => [ nil ], # NCBI UniGene ???
        #"genes" # KEGG Genes
        #"gl" # KEGG Glycan
        #"gn" # KEGG Genomes
        #"gp" # GenPept ???
        "gpu"     => [ nil ], # ???
        "gss"     => [ nil ], # NCBI GSS ???
        "htgs"    => [ nil ], # NCBI HTGS ???
        #"ko" # KEGG Orthology
        "ld"      => [ nil ], # ???
        #"lit" # PRF LitDB
        "mim"     => [ nil ], # ???
        "nt"      => [ nil ], # nr-nt ???
        "og"      => [ nil ], # ???
        #"path" # KEGG Pathway
        "pd"      => [ nil ], # prodom
        #"pdb" # PDB
        "pdoc"    => [ nil ], # Prosite literature (GenomeNet)
        "pf"      => [ nil ], # Pfam
        "pir"     => [ nil ], # pir
        "pmd"     => [ nil ], # Protein mutants (DDBJ) (GenomeNet)
        "pr"      => [ nil ], # prints
        #"prf" # PRF (Protein Research Foundation)
        "ps"      => [ nil ], # prosite
        #"rn" # KEGG Reaction
        #"rp" # KEGG RPair
        #"rs" # NCBI RefSeq
        #"rsaa" # NCBI RefSeq Amino Acide
        #"rsnt" # NCBI RefSeq NucleoTide
        #"sp" # SwissProt
        "str"     => [ nil ], # ???
        "sts"     => [ nil ], # NCBI STS ???
        #"tr" # TrEMBL
        #"vg" # KEGG VGenes
      }

      def initialize(url = URL)
        super
      end

      def fetch(db, id, style = 'raw', format = nil)
        _fetch(:fetch, db, id, style, format)
      end

      def databases
        Databases.collect do |key, val|
          while val && val.is_a?(String)
            val = Databases[val]
          end
          if val && val.is_a?(Array) && val[0] then
            key
          else
            nil
          end
        end.compact
      end

      def formats(database = @database)
        if database
          [ "default" ]
        end
      end

      def maxids
        MAX_ID_NUM
      end

      private
      def _fetch(cmd, db, id, style, format)
        db_orig = db
        db = db.to_s.downcase
        while a = Databases[db]
          case a
          when Array
            break
          when String
            db = a
          else
            break
          end
        end

        if !a and /[a-z]{3}/ =~ db then
          remote = :KEGG
          dbs = [ 'genes' ]
          id_prefix = db
        elsif a.is_a?(Array) then
          remote = a[0]
          dbs = a[1..-1]
          dbs.collect! { |x| x == true ? db : x }
        end
        
        if !remote then
          return "ERROR 1 Unknown database [#{db_orig.inspect}]"
        end
        
        ids = id.strip.split(/(?:\s*\,\s*|\s+)/)
        if ids.size > MAX_ID_NUM then
          return "ERROR 5 Too many IDs [#{ids.size}]. Max [#{MAX_ID_NUM}] allowed."
        end
        if id_prefix then
          ids.collect! { |x| "#{id_prefix}:#{x.strip}" }
        end

        case cmd
        when :fetch
          ret = case remote
                when :TogoWS
                  _fetch_togows(cmd, dbs, ids)
                when :KEGG
                  _fetch_kegg(cmd, dbs, ids)
                when :DBGET
                  _fetch_dbget(cmd, dbs, ids)
                when :PubMed
                  _fetch_pubmed(cmd, dbs, ids)
                else
            raise "Bug: unknown remote site #{remote.inspect}"
          end
        end
        ret
      end

      def _fetch_pubmed(cmd, dbs, ids)
        a = Bio::PubMed.efetch(ids)
        if a && a.size > 0 then
          a.join("\n\n") + "\n"
        else
          "Error 4 ID not found [#{ids.inspect}]"
        end
      end

      def _fetch_togows(cmd, dbs, ids)
        all = []
        ids.each do |id|
          ret = nil
          dbs.each do |db|
            url = "http://togows.org/entry/#{CGI.escape(db)}/#{CGI.escape(id)}"
            begin
              ret = Bio::Command.read_uri(url)
            rescue OpenURI::HTTPError
              ret = nil
            end
            if ret && /\AError/ !~ ret && ret.strip.size > 0 then
              break
            else
              ret = nil
            end
          end
          all.push ret if ret
        end
        if all.empty?
          return "Error 4 ID not found [#{ids.inspect}]"
        else
          return all.join("")
        end
      end
      
      def _fetch_kegg(cmd, dbs, ids)
        all = []
        ids.each do |id|
          ret = nil
          dbs.each do |db|
            if db == "genes" then
              url = "http://rest.kegg.jp/get/#{CGI.escape(id)}"
            else
              url = "http://rest.kegg.jp/get/#{CGI.escape(db)}:#{CGI.escape(id)}"
            end
            begin
              ret = Bio::Command.read_uri(url)
            rescue OpenURI::HTTPError
              ret = nil
            end
            if ret && ret.strip.size > 0 then
              break
            else
              ret = nil
            end
          end
          all.push ret if ret
        end
        if all.empty?
          return "Error 4 ID not found [#{ids.inspect}]"
        else
          return all.join("")
        end
      end

      def _fetch_dbget(cmd, dbs, ids)
        all = []
        ids.each do |id|
          ret = nil
          dbs.each do |db|
            url = "http://www.genome.jp/dbget-bin/www_bget?#{CGI.escape(db)}:#{CGI.escape(id)}"
            begin
              ret = Bio::Command.read_uri(url)
            rescue OpenURI::HTTPError
              ret = nil
            end
            if ret then
              ret = _scrape_dbget(ret)
              break if ret
            end
            ret = nil
          end
          all.push ret if ret
        end
        if all.empty?
          return "Error 4 ID not found [#{ids.inspect}]"
        else
          return all.join("")
        end
      end

      def _scrape_dbget(orig_str)
        a = orig_str.split(/^\s*\<\!\-\- bget\:result \-\-\>$\s*/)
        if a[1] then
          str = a[1]
          str.sub!(/\A\s*\<pre\>$\s*/, "")
          str.sub!(/^\s*\<\/pre\>.*/m, "")
          str.gsub!(/\<[^\>]+\>/, "")
          return str
        end
        nil
      end

    end #class Client

    module Query
      # Shortcut for using BioRuby's BioFetch server. You can fetch an entry
      # without creating an instance of BioFetch server. This method uses the
      # default dbfetch server, which is http://bioruby.org/cgi-bin/biofetch.rb
      #
      # Example:
      #   puts Bio::Fetch.query('refseq','NM_123456')
      #
      # ---
      # *Arguments*:
      # * _database_: name of database to query (see Bio::Fetch#databases to get list of supported databases)
      # * _id_: single ID or ID list separated by commas or white space
      # * _style_: [raw|html] (default = 'raw')
      # * _format_: name of output format (see Bio::Fetch#formats)
      def query(*args)
        Client.new.fetch(*args)
      end
    end #module Query


    class << ::Bio::Fetch

      alias_method :new_without_old_biofetch_emulator, :new

      def new_with_old_biofetch_emulator(*arg)
        if !self.ancestors.include?(Client) &&
            !self.ancestors.include?(::Bio::Fetch::EBI) then
          case arg.size
          when 0
            return Client.new
          when 1
            case arg[0]
            when URL
              return Client.new(*arg)
            end
          end
        end
        new_without_old_biofetch_emulator(*arg)
      end

      alias_method :new, :new_with_old_biofetch_emulator

      include Query

    end #class << Bio::Fetch

  end #module OldBioFetchEmulator

end #module Bio
