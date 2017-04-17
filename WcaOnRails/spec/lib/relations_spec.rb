# frozen_string_literal: true

require 'relations'

RSpec.describe "Relations" do
  before do
    allow(Relations).to receive(:linkings).and_return(
      "2013KOSK01" => %w(2005FLEI01 2008VIRO01),
      "2005FLEI01" => %w(2013KOSK01 2008VIRO01 1982PETR01),
      "2008VIRO01" => %w(2013KOSK01 2005FLEI01 1982PETR01),
      "1982PETR01" => %w(2005FLEI01 2008VIRO01),
    )
  end

  describe ".get_chain" do
    it "returns any of shortest valid chains linking two people" do
      chain = Relations.get_chain("2013KOSK01", "1982PETR01")
      expect([
        %w(2013KOSK01 2005FLEI01 1982PETR01),
        %w(2013KOSK01 2008VIRO01 1982PETR01),
      ].include?(chain)).to eq true
    end
  end

  describe ".extended_chains_by_one_degree!" do
    it "extends each chain by one degree" do
      # Degree: 0
      chains = [["2013KOSK01"]]
      # Degree: 1
      Relations.extended_chains_by_one_degree! chains
      expect(chains).to match_array [
        %w(2013KOSK01 2005FLEI01),
        %w(2013KOSK01 2008VIRO01),
      ]
      # Degree: 2
      Relations.extended_chains_by_one_degree! chains
      expect(chains).to match_array [
        %w(2013KOSK01 2005FLEI01 2013KOSK01),
        %w(2013KOSK01 2005FLEI01 2008VIRO01),
        %w(2013KOSK01 2005FLEI01 1982PETR01),

        %w(2013KOSK01 2008VIRO01 2013KOSK01),
        %w(2013KOSK01 2008VIRO01 2005FLEI01),
        %w(2013KOSK01 2008VIRO01 1982PETR01),
      ]
    end
  end

  describe ".random_final_chain" do
    it "finds a final chain linking two people from given arrays of partial chains" do
      final_chain = Relations.random_final_chain(
        [%w(2013KOSK01 2005FLEI01), %w(2013KOSK01 2011KNOT01)],
        [%w(1982PETR01 2003BRUC01), %w(1982PETR01 2005FLEI01)],
      )
      expect(final_chain).to eq %w(2013KOSK01 2005FLEI01 1982PETR01)
    end
  end
end
