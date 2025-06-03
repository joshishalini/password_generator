# Password Generator

A simple, configurable Ruby library for generating secure passwords.


## 🔧 Features

- Define total password length
- Include exact number of digits and special characters
- Ensure at least one uppercase/lowercase character
- Validates input for logical consistency
- Fully tested with RSpec

## 🚀 Usage

```ruby
require_relative 'lib/password/generator'

generator = Password::Generator.new(
  length: 8,
  uppercase: true,
  lowercase: true,
  number: 2,
  special: 1
)

puts generator.generate
# => e.g., "A7S1!uRq"

```
## ⚙️ Test

```ruby
bundle install
rspec
```
