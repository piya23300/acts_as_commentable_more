# ActsAsCommentableMore

[![Gem Version](https://badge.fury.io/rb/acts_as_commentable_more.svg)](http://badge.fury.io/rb/acts_as_commentable_more)
[![Build Status](https://travis-ci.org/piya23300/acts_as_commentable_more.svg)](https://travis-ci.org/piya23300/acts_as_commentable_more)
[![Dependency Status](https://gemnasium.com/piya23300/acts_as_commentable_more.svg)](https://gemnasium.com/piya23300/acts_as_commentable_more)
[![Coverage Status](https://coveralls.io/repos/piya23300/acts_as_commentable_more/badge.svg)](https://coveralls.io/r/piya23300/acts_as_commentable_more)

---
## Thank you
acts_as_commentable_more develops from [acts_as_commentable](https://github.com/jackdempsey/acts_as_commentable).

Thank you very much for way and inspiration.

### Generator

Generate model and migration
```ruby
rails generate commentable your_model_name
```
---

### Basic Usege
### Setting
Model would like to have commentable.

```ruby
    class Post < ActiveRecord::Base
    acts_as_commentable # default options types: [:comment], options: { class_name: 'Comment', as: :commentable }, as: :comments
  end
```

```ruby
post = Post.create #<Post>

#get all comments of post
comments = post.comments #<ActiveRecord::Associations::CollectionProxy []>

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
    acts_as_commentable types: [:private, :public] # default options: { class_name: 'Comment', as: :commentable }, as: :comments
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

### Options
```ruby
acts_as_commentable types: [:show, :hide], options: { class_name: 'CustomComment', as: :custom_commentable }, as: notes
```

- type : type of comment #array
- options : association options #hash
    - class_name : class name of comment
    - as : polymorephic name
- as : name of association



## LICENSE
This project rocks and uses MIT-LICENSE.
