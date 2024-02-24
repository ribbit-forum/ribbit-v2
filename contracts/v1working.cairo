

#[derive(Drop, Serde, starknet::Store)]
struct Post {
    message: felt252, // bytearray
    deleted: bool,
}

#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn set(ref self: TContractState, x: u128);
    fn get(self: @TContractState) -> u128;
    fn getPostLength(self: @TContractState) -> u128;
    fn addPost(ref self: TContractState, message: felt252);
    fn getAllPosts(self: @TContractState) -> Array<Post>;
}

#[starknet::contract]
mod SimpleStorage {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use array::ArrayTrait;
    use super::Post;


    #[storage]
    struct Storage {
        posts: LegacyMap::<u128, Post>,
        stored_data: u128,
        postLength: u128,
    }


    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set(ref self: ContractState, x: u128) {
            self.stored_data.write(x);
        }
        fn get(self: @ContractState) -> u128 {
            self.stored_data.read()
        }
        fn getPostLength(self: @ContractState) -> u128 {
            self.postLength.read()
        }
        fn addPost(ref self: ContractState, message: felt252) {
            let _new_post = Post {
                message: message,
                deleted: false
            };
            let _currentPostLength = self.postLength.read();
            self.posts.write(_currentPostLength, _new_post);
            self.postLength.write(_currentPostLength + 1);
        }
        fn getAllPosts(self: @ContractState) -> Array<Post> {
            let _currentPostLength = self.postLength.read();
            let mut index = 0;
            let mut result:Array<Post> = ArrayTrait::new();
            while index != _currentPostLength {
                let post = self.posts.read(index);
                result.append(post);
                index += 1;
            };
            return result;
        }


    }
}
