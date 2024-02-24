#[starknet::contract]
mod SocialMedia {
    use starknet::{
        get_caller_address, ContractAddress, felt, get_current_epoch_seconds,
    };

    #[derive(Copy, Clone)]
    struct Post {
        user_address: felt,
        title: [felt; 10], 
        content: [felt; 20], 
        date_submitted: i64,
        topic: [felt; 5], 
        likes: i64,
    }

    #[storage]
    struct PostsStorage {
        posts: Vec<Post>,
    }

    #[starknet::interface]
    trait IPosts {
        fn view_posts(self: @PostsStorage) -> Vec<Post>;
        fn add_post(ref self: PostsStorage, title: [felt; 10], content: [felt; 20], topic: [felt; 5]);
    }

    impl SocialMedia of super::IPosts {
        fn view_posts(self: @PostsStorage) -> Vec<Post> {
            self.posts.clone()
        }

        fn add_post(ref self: PostsStorage, title: [felt; 10], content: [felt; 20], topic: [felt; 5]) {
            let new_post = Post {
                user_address: get_caller_address(),
                title,
                content,
                date_submitted: get_current_epoch_seconds(),
                topic,
                likes: 0,
            };
            self.posts.push(new_post);
        }
    }
}

fn main() {}
