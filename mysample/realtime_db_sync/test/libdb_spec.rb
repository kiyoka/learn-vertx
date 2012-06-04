#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
#
# libdb_spec.rb -  "RSpec file for libdb"
#
#   Copyright (c) 2012-2012  Kiyoka Nishiyama  <kiyoka@sumibi.org>
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#
#   1. Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#
#   3. Neither the name of the authors nor the names of its contributors
#      may be used to endorse or promote products derived from this
#      software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
require 'libdb'
require 'libutil'
include DBSync

DBPATH="/tmp/libdb.db"

def generateSampleData()


end

describe MasterDB, "masterDB API operations are " do

  before do
    @masterdb = MasterDB.new
    @masterdb.open( "user1" )
    @util = Util.new

    ###         date,                           value
    @data = [[ "1338738983:06/04/12:00:56:22",  "first data" ],
             [ "1338814085:06/04/12:21:48:04",  "text data1" ]]
  end

  it "should" do
    @masterdb.clear( )
    @masterdb.getList( ).should == []

    @data.each { |entry|
      date  = entry[0]
      value = entry[1]
      digest = @util.digest( value )
      key = date + "-" + digest
      @masterdb.insertValue( key, value )
    }

    keys = @masterdb.getList( )
    keys.should == 
      ["1338738983:06/04/12:00:56:22-663ea86d450042b6e7ea651f492e4109cb9e875b",
       "1338814085:06/04/12:21:48:04-f0c62da87f30bff2543cbd44733c17ea9ba84f68"]
    
    @masterdb.getValue( keys[0] ).should == 'first data'
    @masterdb.getValue( keys[1] ).should == 'text data1'

    date = "1338814090:06/04/12:21:48:09"
    key = date + "-" + @util.digest( 'text data2' )
    @masterdb.insertValue( key, 'text data2' )
    
    keys = @masterdb.getList( )
    keys.size.should                     == 3
    keys.should                          ==
      ["1338738983:06/04/12:00:56:22-663ea86d450042b6e7ea651f492e4109cb9e875b",
       "1338814085:06/04/12:21:48:04-f0c62da87f30bff2543cbd44733c17ea9ba84f68",
       "1338814090:06/04/12:21:48:09-19dd9dda20e2fe783b5408a614a6b3c4357beace"]

    @masterdb.getValue( keys[2] ).should == 'text data2'

  end
end