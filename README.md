# ActsAsCommentableMore

[![Gem Version](https://badge.fury.io/rb/acts_as_commentable_more.svg)](http://badge.fury.io/rb/acts_as_commentable_more)
[![Build Status](https://travis-ci.org/piya23300/acts_as_commentable_more.svg)](https://travis-ci.org/piya23300/acts_as_commentable_more)
[![Dependency Status](https://gemnasium.com/piya23300/acts_as_commentable_more.svg)](https://gemnasium.com/piya23300/acts_as_commentable_more)
[![Code Climate](https://codeclimate.com/github/piya23300/acts_as_commentable_more/badges/gpa.svg)](https://codeclimate.com/github/piya23300/acts_as_commentable_more)
[![Coverage Status](https://coveralls.io/repos/piya23300/acts_as_commentable_more/badge.svg)](https://coveralls.io/r/piya23300/acts_as_commentable_more)

---
## Thank you
acts_as_commentable_more develops from [acts_as_commentable](https://github.com/jackdempsey/acts_as_commentable).

Thank you very much for way and inspiration.

### What acts_as_commentable_more bring "more"
1. It has friendly method for usage developer
2. It has flexible method's name
3. It has many functions
    * any user's type of comment in the same table
    * any object owner of comment in the same table
    * cache comment counts
    * [future] reply comment


### Generator

Generate model and migration
```ruby
rails generate commentable your_model_name
```
---

### Basic Usege
### Setting
Model would like to have comments.

```ruby
class Post < ActiveRecord::Base
  acts_as_commentable :comments # default options types: [:comment], options: { class_name: 'Comment', as: :commentable }, counter_cache: :true
end
```

usage
```ruby
post = Post.create #<Post>

#get all comments of post
comments = post.comments #[<Comemnt>]

#create comment of post
comment = post.creates_comments(message: 'new message') #<Comment>
comment = post.comments.create(message: 'new message') #<Comment>

#get owner comment
user = User.create

comment = post.creates_comments(message: 'I am user', user: user)
comment.user #<User>

```

### Any type of user in the same table
```ruby
post = Post.create #<Post>

admin = Admin.create
user = User.create

comment = post.creates_comments(message: 'I am user', user: user)
comment.user #<User>

comment = post.creates_comments(message: 'I am admin', user: admin)
comment.user #<Admin>

```

### Many type of comment
Setting Model
```ruby
    class Post < ActiveRecord::Base
    acts_as_commentable :comments, types: [:private, :public] # default options: { class_name: 'Comment', as: :commentable }
  end
```

usage
```ruby
post = Post.create #<Post>

#get all private comments of post
private_comments = post.private_comments #[<Comment role: 'private'>]

#get all public comments of post
public_comments = post.public_comments #[<Comment role: 'public'>]

#get all comment of post
comments = post.all_comments #[<Comment>]

#create private comments
private_comment = post.creates_private_comments(message: 'private message') #<Comment role: 'private'>

#create public comments
public_comment = post.creates_public_comments(message: 'public message') #<Comment role: 'public'>

```

### Helper Method

#### For many types of comment
```ruby
post = Post.create #<Post>

private_comment = post.creates_private_comments #<Comment>

#Checked type of comment
private_comment.is_private? #true
private_comment.is_public? #false

#Changed type of comment
private_comment.to_public #not save
private_comment.to_public! #save
```

### Cache Counter
You can enable at ```counter_cache```
```ruby
acts_as_commentable :comments, counter_cache: true # default true
```
Note. Don't enable at ```belongs_to``` of ```your_comment Model```

Posts table add a field
```ruby
class AddCommentsCountToPost < ActiveRecord::Migration
  def change
    add_column :posts, :comments_count, :integer, default: 0
  end
end
```

if you would like to have many types
```ruby
add_column :posts, :comments_count, :integer, default: 0
add_column :posts, :private_comments_count, :integer, default: 0
add_column :posts, :public_comments_count, :integer, default: 0
```

if you adjust association class name. you have to add
```ruby
add_column :posts, :{plural model name of comment that setting}_count, :integer, default: 0
```
example
```ruby
acts_as_commentable :notes
```
you have to add
```ruby
add_column :posts, :notes_count, :integer, default: 0
```

### Related Attributes of Comment
support Postgrasql only
```ruby
post = Post.create

comment = post.creates_comments(related_attributes: {ip_address: "xxx.xxx.xxx"})
comment.related_attributes[:ip_address] #"xxx.xxx.xxx"
```

it's auto merged hash
```ruby
comment = post.creates_comments(related_attributes: {ip_address: "xxx.xxx.xxx"})
# comment.related_attributes => { "ip_address" => "xxx.xxx.xxx" }
comment.related_attributes[:more_attr] = "more value"
# comment.related_attributes => { "ip_address" => "xxx.xxx.xxx", "more_attr" => "more value" }
```

### Options
```ruby
acts_as_commentable :comments, types: [:comment], options: { class_name: 'Comment', as: :commentable }, counter_cache: true
```

- first parameter is association's name
- types : type of comment #array
- options : association options #hash
    - class_name : class name of comment
    - as : polymorephic name
- counter_cache : enable/disable


If you would like to change suffix name of all method.
when you have many types. you can change fist parameter likes `notes`

```ruby
    class Post < ActiveRecord::Base
    acts_as_commentable :notes, types: [:private, :public], default options: { class_name: 'Comment', as: :commentable }
  end
```

usage
```ruby
post = Post.create #<Post>

#get all private notes of post
private_notes = post.private_notes #[<Comment role: 'private'>]

#get all public notes of post
public_notes = post.public_notes #[<Comment role: 'public'>]

#get all notes of post
notes = post.all_notes #[<Comment>]

#create private notes
private_note = post.creates_private_notes(message: 'private message') #<Comment role: 'private'>

#create public notes
public_note = post.creates_public_notes(message: 'public message') #<Comment role: 'public'>

```


## LICENSE
This project rocks and uses MIT-LICENSE.
