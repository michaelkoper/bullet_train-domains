class DomainsTest < ActiveSupport::TestCase
  test "defaults to initialized status" do
    domain = Domain.new
    assert_equal "initialized", domain.status
    assert domain.initialized?
  end

  test "has status predicate methods for all statuses" do
    domain = Domain.new(address: "test.example.com")
    %w[initialized connected owner_verified active].each do |state|
      domain.status = state
      assert domain.send("#{state}?"), "Expected #{state}? to be true when status is #{state}"

      (Domain::STATUSES - [ state ]).each do |other_state|
        assert_not domain.send("#{other_state}?"),
          "Expected #{other_state}? to be false when status is #{state}"
      end
    end
  end
end
