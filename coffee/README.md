# From writing specs to running them

## Learning Objectives

- How to generate readable documentation from your specs
- How to identify the slowest examples in your suite
- How to run just the specs you care about at any given time
- How to mark work-in-progress specs and come back to them later

Example:

```ruby
RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eq(1.0)
  end

  context 'with milk' do
    before { coffee.add :milk }

    it 'costs $1.25' do
      expect(coffee.price).to eq(1.25)
    end
  end
end
```

This spec file uses the same techniques as the sandwich example, with a new addon the `context` block. The `context` block is used to group examples that share a common context. In this case, the context is that the coffee has milk in it. The `before` block is used to set up the context for the examples in the `context` block. `context` is just an alias for `describe`, but we use `context` for phrases that modify the object we are testing, the way `with milk` modifies `A cup of coffee`.


## The Document Formatter

RSpec comes with a built-in formatter that generates documentation from your specs. To use it, pass the `--format documentation` option to `rspec`:

```bash
rspec --format documentation
```

The output will look something like this:

```bash
A cup of coffee
  costs $1
  with milk
    costs $1.25
```

This is a great way to get a quick overview of your specs. It's also a great way to get a quick overview of your code. If you have a spec that is hard to understand, you can use the documentation formatter to help you figure out what it's doing.

## The Progress Formatter

The progress formatter is the default formatter. It prints a dot for each passing example, an `F` for each failing example, and an `E` for each example that raises an error. It also prints a summary of the number of examples that passed, failed, and errored at the end of the run.

## The Profile Formatter

The profile formatter prints a report of the 10 slowest examples in your suite. To use it, pass the `--format profile` option to `rspec`:

```bash
rspec --format profile
```

The output will look something like this:

```bash
Top 10 slowest examples (0.00004 seconds, 0.0% of total time):
  A cup of coffee with milk costs $1.25
    0.00004 seconds ./spec/coffee_spec.rb:10
```

This is a great way to identify the slowest examples in your suite. If you have a spec that is slow, you can use the profile formatter to help you figure out why it's slow. With the profile formatter we can also pass in a specific number of examples to list. For example, if we wanted to see the 5 slowest examples, we could pass the `--profile 5` option to `rspec`:

```bash
rspec --profile 5
```

## Running just what you need

RSpec provides a number of ways to run just the specs you care about at any given time. The simplest way is to pass the line number of the example you want to run. For example, if you want to run just the example in the `coffee_spec.rb` file that is on line 10, you can do this:

```bash
rspec spec/coffee_spec.rb:10
```

But this is a bit tedious. RSpec provides a number of other ways to run just the specs you care about. For example, you can use the `--example` option to run just the examples whose full description matches the given string. For example, if you want to run just the example in the `coffee_spec.rb` file that has the full description `A cup of coffee with milk costs $1.25`, you can do this:

```bash
rspec --example 'A cup of coffee with milk costs $1.25' spec/coffee_spec.rb
```

Another way of using the `--example` or `-e` option is to pass it a search term and RSpec will just run the examples containing that search term in their description. For example, if you want to run just the examples in the `coffee_spec.rb` file that have the word `milk` in their description, you can do this:

```bash
rspec -e milk -fd
```

You can also load specific files or directories. For example, if you want to run just the specs in the `spec/models` directory, you can do this:

```bash
rspec spec/models
```

You can also use the `--tag` option to run just the examples that have been tagged with the given tag. For example, if you want to run just the examples in the `coffee_spec.rb` file that have been tagged with `:focus`, you can do this:

```bash
rspec --tag focus spec/coffee_spec.rb
```

## Running Specific Failures

Often times when you have a suite of tests that is failing, you might want to run just the failures. RSpec provides a number of ways to do this. The simplest way is to use the `--only-failures` option. For example, if you want to run just the failures from the last run, you can do this:

```bash
rspec --only-failures
```

This flag requires a bit of configuration. To use `--only-failures`, you need to tell RSpec where to store the failures so that it knows what to rerun. You simply supply a filename through the RSpec.configure method, which is a catch-all for lots of different runtime options.

```ruby
RSpec.configure do |config|
  config.example_status_persistence_file_path = "spec/examples.txt"
end
```

You will need to rerun RSpec again without any flags to (record passing/failing status) and generate the file. Once you have the file, you can run just the failures with the `--only-failures` option.

Another option is to use the `--next-failure` option. For example, if you want to run just the next failure from the last run, you can do this:

```bash
rspec --next-failure
```

## Focusing Specific Examples

If you find yourself running the same subset of specs repeatedly, you can save time by marking them as focused. You can do this by simple adding an `f` to the beginning of the RSpec method name:

- `context` becomes `fcontext`
- `it` becomes `fit`
- `describe` becomes `fdescribe`

After you need to configure RSpec to run just the focused examples. You can edit the `RSpec.configure` block we used for running just the failed examples.

```ruby
RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/examples.txt'
end
```

Now, when you run RSpec, it will only run the focused examples. You can also use the `--tag` option to run just the examples that have been tagged with the given tag. For example, if you want to run just the examples in the `coffee_spec.rb` file that have been tagged with `:focus`, you can do this:

```bash
rspec --tag focus spec/coffee_spec.rb
```

> Note: adding an `f` to the beginning of the RSpec method name is also the same thing as tagging the example with `:focus`. In fact, the `fdescribe`, `fit`, and `fcontext` methods are just aliases for `describe`, `it`, and `context` with the `:focus` tag.

```
fcontext 'with milk' do
```

is the same as

```
context 'with milk', :focus do
```

## Marking work-in-progress 

In Behaviour Driven Development, it is common to write the specs for a feature before writing the code to make the specs pass. This is a great way to get a high-level overview of the feature you are building. However, it is also common to have a number of specs that are not yet passing. You can use the `pending` method to mark these specs as pending. For example, if you want to mark the example in the `coffee_spec.rb` file that has the full description `A cup of coffee with milk costs $1.25` as pending, you can do this:

```ruby
it 'A cup of coffee with milk costs $1.25' do
  pending 'Not implemented yet'
  expect(Coffee.new(:milk).price).to eq(1.25)
end
```

When you run RSpec, it will print out the specs that are pending. For example:

```bash
rspec spec/coffee_spec.rb
```

```
Pending: (Failures listed here are expected and do not affect your suite's status)

  1) A cup of coffee with milk costs $1.25
     # Not implemented yet
     # ./spec/coffee_spec.rb:10
```

### Completing work-in-progress

When you are ready to complete the pending specs, you can simply remove the `pending` method. For example, if you want to complete the example in the `coffee_spec.rb` file that has the full description `A cup of coffee with milk costs $1.25`, you can do this:

```ruby
it 'A cup of coffee with milk costs $1.25' do
  expect(Coffee.new(:milk).price).to eq(1.25)
end
```
  
## Skipping Examples

Sometimes you might want to skip an example. For example, if you are writing a spec for a feature that is not yet implemented, you might want to skip the spec until the feature is implemented. You can use the `skip` method to mark an example as skipped. For example, if you want to mark the example in the `coffee_spec.rb` file that has the full description `A cup of coffee with milk costs $1.25` as skipped, you can do this:

```ruby
it 'A cup of coffee with milk costs $1.25' do
  skip 'Not implemented yet'
  expect(Coffee.new(:milk).price).to eq(1.25)
end
```

When you run RSpec, it will print out the specs that are skipped. For example:

```bash
rspec spec/coffee_spec.rb
```

```
Skipped: (Failures listed here are expected and do not affect your suite's status)

  1) A cup of coffee with milk costs $1.25
     # Not implemented yet
     # ./spec/coffee_spec.rb:10
```

A shorthand you can use is to add an `x` to the beginning of the RSpec method name like we did with focus:

- `context` becomes `xcontext`
- `it` becomes `xit`
- `describe` becomes `xdescribe`
