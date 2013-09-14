requirejs(['example'], function(example) {
  describe("Example", function() {
    it("should have a message equal to 'Hello!'", function() {
      console.log(example.message);
      expect(example.message).toBe('Hello!');
    });
  });
});
