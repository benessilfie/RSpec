# First Spec

RSpec uses the words `describe` and `it` to define a spec. The `describe` method takes a string and a block. The string is the name of the thing you are describing, and the block contains the spec or test cases. The `it` method takes a string and a block. The string is the name of the exact case or spec, and the block contains the code that tests that spec.

Example:

```ruby
RSpec.describe 'An ideal sandwich' do
  it 'is delicious' do 
    sandwich = Sandwich.new('delicious', [])
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end
```

Here we are saying, "An ideal sandwich is delicious". We are not actually testing anything yet, we are just setting up the framework for our tests. We arebasically describing an ideal sandwich and saying that for now it is delicious.

## Groups, Examples, and Expectations

This example defines our tests, also known as specs in RSpec, short for specifications because they `specify` the behavior of your code. The `RSpec.describe` block creates an `example group` and keep the related specs together. An `example group` defines what you are testing in this case a sandwich.

The `it` block is an example. It is a specific test case. It is a single expectation that the sandwich is delicious.

The `expect` method is an expectation. It is a statement that describes the expected behavior of the code. The `expect` method takes a value and a matcher. The matcher is a method that takes the value and compares it to the expected value. The matcher returns true or false. If the matcher returns true, the test passes. If the matcher returns false, the test fails.

In the example we follow the Arrange/Act/Assert pattern: Set up an object, do something with it and check if it behaves the way you expect it to. Here we create a Sandwich, ask for its taste and confirm if the result is delicious. We set up an object with `sandwich = Sandwich.new('delicious', [])`, did something with it by asking for its taste `taste = sandwich.taste` and made an assertion to know if it was delicious.

## Matchers

The `expect` method takes a value and a matcher. The matcher is a method that takes the value and compares it to the expected value. The matcher returns true or false. If the matcher returns true, the test passes. If the matcher returns false, the test fails.

The matcher `eq` takes the value and compares it to the expected value. If the value is equal to the expected value, the matcher returns true and the test passes. If the value is not equal to the expected value, the matcher returns false and the test fails.

Example 2:

```ruby
RSpec.describe 'An ideal sandwich' do
  it 'is delicious' do 
    sandwich = Sandwich.new('delicious', [])
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich = Sandwich.new('delicious', [])
    sandwich.add_topping('cheese')
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```

The expectation for the second example is `expect(toppings).not_to be_empty`. The matcher `be_empty` returns true if the value is empty. In this case, the value is an array of toppings. If the array is empty, the matcher returns false and the test fails. If the array is not empty, the matcher returns true and the test passes. 

This specs runs fine but its a little repetitive. We are creating a sandwich in both tests. We can make a common sandwich for both tests in multiple ways in RSpec.

- Hooks
- Helper Methods
- Using `let`

## Hooks

Hooks are blocks of code that run before or after each example or group of examples. They are used to set up or clean up the environment for your tests. There are four types of hooks: `before`, `after`, `around`, and `let`. 

### Before

The `before` hook runs before each example in the group. It is used to set up the environment for your tests. You can use it to create a common object for your tests. RSpec keeps track of all the hooks registered, each time RSpec is about to start running one of the examples, it will first run any `before` hooks that apply. In the example below the `@sandwich` instance variable will be set up and ready to use. The setup code is shared across specs but the individual `Sandwich` instance is not. Every example gets it own sandwich.

Example 3:

```ruby
RSpec.describe 'An ideal sandwich' do
  before { @sandwich = Sandwich.new('delicious', []) }

  it 'is delicious' do 
    taste = @sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    @sandwich.add_topping('cheese')
    toppings = @sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```

### After

The `after` hook runs after each example in the group. It is used to clean up the environment after your tests. You can use it to delete a common object for your tests.

Example 4:

```ruby
RSpec.describe 'An ideal sandwich' do
  before { @sandwich = Sandwich.new('delicious', []) }
  after { @sandwich = nil }

  it 'is delicious' do 
    taste = @sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    @sandwich.add_topping('cheese')
    toppings = @sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```

### Around

The `around` hook runs before and after each example in the group. It is used to set up and clean up the environment for your tests. You can use it to create a common object for your tests and delete it after the tests.

Example 5:

```ruby
RSpec.describe 'An ideal sandwich' do
  around(:each) do |example|
    @sandwich = Sandwich.new('delicious', [])
    example.run
    @sandwich = nil
  end

  it 'is delicious' do 
    taste = @sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    @sandwich.add_topping('cheese')
    toppings = @sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```

Hooks are great for running set up and clean up code. They are also great for sharing common code across examples. For example if you need to clear out a test database before each example, a hook is a great a place to start.

## Helper Methods

RSpec does a lot for us, but under the hood it is just Ruby. We can use Ruby to create helper methods to share code across examples. Each example group is a Ruby class, which means we can define methods on it.

In our toppings example we call sandwich twice. Each call creates a new instance of `Sandwich`. So, the sandwich we added toppings to is a different one than the sandwich we are checking

Example 6:

```ruby
RSpec.describe 'An ideal sandwich' do
  def sandwich
    @sandwich ||= Sandwich.new('delicious', [])
  end

  it 'is delicious' do 
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich.add_topping('cheese')
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```


### Let

The `let` method is used to define a helper method. The method is only run when it is called. The value is cached between multiple calls in the same example but not across examples. It is used to set up the environment for your tests. You can use it to create a common object for your tests.

Example 7:

```ruby
RSpec.describe 'An ideal sandwich' do
  let (:sandwich) { Sandwich.new('delicious', []) }

  it 'is delicious' do 
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich.add_topping('cheese')
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
```



