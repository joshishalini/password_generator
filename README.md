# Password Generator

A simple, configurable Ruby library for generating secure passwords.

## Personal Note

Thanks for taking the time to have another look. I really appreciate it.

I know the earlier submission felt rushed, I should have taken a bit more time to do it justice. I’ve cleaned things up, added better error handling, comments, and tests.

Thanks again for your the feedback, it genuinely helped.


## Installation

```
git clone https://github.com/your-username/password-generator.git
cd password-generator
bundle install
```


## Features

- Define total password length
- Specify exact number of digits and special characters
- Ensure at least one uppercase/lowercase character
- Validates input for logical consistency
- Fully tested with RSpec

## Usage

```ruby
require_relative 'lib/password/generator'

generator = Password::Generator.new(
  length: 12,
  uppercase: true,
  lowercase: true,
  number: 2,
  special: 1
)

result = generator.generate

if result[:success]
  puts "Generated Password: #{result[:password]}"
else
  puts "Error: #{result[:error]}"
end

Example output: {:success=>true, :password=>"A2k@z9dfuLp3"}

```

# Example Invalid Usage

```ruby
generator = Password::Generator.new(length: "ten", uppercase: true, lowercase: nil, number: "two", special: 1)
result = generator.generate
puts result
result {:success=>false, :error=>["Lowercase must be provided.", "Length must be an integer.", "Number must be a non-negative integer.", "Lowercase must be a boolean value."]}

puts result[:error] # => ["Lowercase must be provided.", "Length must be an integer.", "Number must be a non-negative integer.", "Lowercase must be a boolean value."]

```

## ⚙️ Test

```ruby
bundle install
rspec
```
