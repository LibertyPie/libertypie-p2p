// SPDX-License-Identifier: MIT
// File: contracts/PermissionManager/PM.sol


pragma solidity ^0.6.2;


interface IPermissionManager {
    function isSuperAdmin(address _address) external view  returns(bool);
    function isAdmin(address _address) external view  returns(bool);
    function isModerator(address _address) external view returns (bool);
}

contract PM {

    IPermissionManager public PERMISSION_MANAGER;

    /**
     * @dev  set permission manager contract
     */
    function _setPermissionManager(address _newAddress) internal {
        PERMISSION_MANAGER = IPermissionManager(_newAddress);
    }

    /**
     * @dev  set permission manager contract
     */
    function setPermissionManager(address _newAddress) external onlySuperAdmins () {
      _setPermissionManager(_newAddress);
    }

    /**
     * onlySuperAdmin - a modifier which allows only super admin 
    */
     modifier onlySuperAdmins () {
         require( PERMISSION_MANAGER.isSuperAdmin(msg.sender), "ONLY_SUPER_ADMINS_ALLOWED" );
         _;
     }

    /**
    * OnlyAdmin 
    * This also allows super admins
    */
    modifier onlyAdmins () {
      require( PERMISSION_MANAGER.isAdmin(msg.sender), "ONLY_ADMINS_ALLOWED");
      _;
    }

    /**
    * OnlyModerator
    */
    modifier onlyModerators() {
      require( PERMISSION_MANAGER.isModerator(msg.sender), "ONLY_MODERATORS_ALLOWED" );
      _;
    }

} //end function

// File: contracts/Oracles/OpenPriceFeed.sol

pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


interface UniswapAnchoredView {
    function price(string calldata symbol) external view returns (uint);
}

contract OpenPriceFeed is PM {

    //if the uniswap anchor contract is changed
    event uniswapAnchorContractChanged(address indexed _newAddress);

    //uniswap anchored view contract
    UniswapAnchoredView public  UNISWAP_ANCHORED_VIEW;

    constructor() public {

        //default to ethereum mainnet 
        address  _contractAddress = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;

        UNISWAP_ANCHORED_VIEW = UniswapAnchoredView(_contractAddress);
    }

    /**
     * @dev update uniswap anchor contract
     * @param _newAddress  the new contract address
     */
    function _setUniswapAnchorContract(address _newAddress) internal  {
        
        UNISWAP_ANCHORED_VIEW = UniswapAnchoredView(_newAddress);

        //emit event
        emit uniswapAnchorContractChanged(_newAddress);

    } //end  fun


    /**
     * @dev update uniswap anchor contract
     * @param _newAddress  the new contract address
     */
    function setUniswapAnchorContract(address _newAddress) external onlyAdmins()  {
        _setUniswapAnchorContract(_newAddress);
    }

    /**
     * getLatestPrice
     */
    function getLatestPrice(string memory _symbol) internal view returns (uint256) {
        return UNISWAP_ANCHORED_VIEW.price(_symbol);
    } //end fun


}//end

// File: contracts/PriceFeed.sol


pragma solidity ^0.6.2;


contract PriceFeed is  OpenPriceFeed {

   /**
   * @dev get latest price in usd
   */
   function getPriceUSD(string memory _symbol) public view returns (uint256) {
      (uint256 _price) = OpenPriceFeed.getLatestPrice(_symbol);
      return _price;
   }

   /**
    * configure open price feed contract
    */
    function configureOpenPriceFeed(address _contractAddress) internal {
      OpenPriceFeed._setUniswapAnchorContract(_contractAddress);
    }

}  //end contract

// File: @openzeppelin/contracts/GSN/Context.sol


pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/math/SafeMath.sol


pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol


pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


pragma solidity ^0.6.0;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: contracts/Assets.sol


pragma solidity ^0.6.2;




contract Assets is PM {

    PriceFeed _priceFeed = PriceFeed(address(this));

    /**
     * @dev mapping for  assetsData 
     */
    mapping(uint256 => AssetItem) internal  AssetsData;

    //set initially at 0, 
    //0 index wont be used due  to solidity behaviour over non existent data
    uint256  private totalAssets;

    // assetsDataIndexes 
    // format mapping(assetContractAddress  => index )
    mapping(address => uint256) internal AssetsDataIndexes;

    /**
     * @dev asset struct item
     */
    struct AssetItem {
        uint256  index;
        string   symbol;
        string   name;
        address  contractAddress;
        uint8    decimals;
        bool     isPegged;
        string   originalName;
        string   originalSymbol;
        address  wrapperContract;
        uint256  price;
        bool     isEnabled;
        uint256  createdAt;
        uint256  updatedAt;
    }


    /**
     * @dev add a new asset to supported list
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     */
    function _addAsset(
        address _contractAddress, 
        bool    _isPegged,
        string memory  _originalName,
        string memory _originalSymbol,
        address _wrapperContract
    ) private {
        
        //fetch contract  info
        ERC20 erc20Token = ERC20(_contractAddress);

         if(bytes(_originalName).length == 0){
            _originalName  = erc20Token.name();
        }


        if(bytes(_originalSymbol).length == 0){
            _originalSymbol  = erc20Token.symbol();
        }
        
        uint256 _index = totalAssets++;

        AssetItem memory assetItem = AssetItem(
            _index,
            erc20Token.symbol(),
            erc20Token.name(),
            _contractAddress,
            erc20Token.decimals(),
            _isPegged,
            _originalName,
            _originalSymbol,
            _wrapperContract,
            _priceFeed.getPriceUSD(_originalSymbol),
            true,
            block.timestamp,
            block.timestamp
        );


        //lets insert the data 
        AssetsData[_index] = assetItem;

        AssetsDataIndexes[_contractAddress] = _index;

    }//end fun


     /**
     * @dev add a new asset to supported list
     * @param _contractAddress asset's contract address
     * @param _isPegged a  boolean describing wether its pegged  or not
     * @param _originalName if pegged, then original asset name
     * @param _originalSymbol if pegged, the original symbol
     *  @param _wrapperContract smart contract for wrapping  and unwrapping the asset 
     */
    function addAsset(
        address _contractAddress, 
        bool    _isPegged,
        string calldata  _originalName,
        string calldata  _originalSymbol,
        address _wrapperContract
    ) external onlyAdmins() {
        return _addAsset(_contractAddress, _isPegged, _originalName, _originalSymbol, _wrapperContract);
    }
        

     /**
     * @dev fetch asset by it contract address
     * @param _contractAddress asset's contract address
     * @return AssetItem
     */
    function _getAsset(address _contractAddress) private  view returns (AssetItem memory) {
        
        uint256 assetIndex = AssetsDataIndexes[_contractAddress];

        AssetItem memory assetItem = AssetsData[assetIndex];

        require(isValidAssetItem(assetItem),"XPIE:UNKNOWN_ASSET");

        assetItem.price =  _priceFeed.getPriceUSD(assetItem.symbol);

        return assetItem;
    } //end function
    
 
    /**
     * @dev fetch asset by it contract address
     *  @param _contractAddress  asset contract address
     *  @return (   string memory, string memory, address, uint8, string memory,  string memory, bool  )
     */
    function getAsset(address _contractAddress) external  view returns (AssetItem memory) {
        return _getAsset(_contractAddress);
        //return  (asset.symbol, asset.name, asset.contractAddress, asset.decimals, asset.assetAlias, asset.isEnabled);
    } //end fun

    /**
     * @dev check if the asset is valid or enabled 
     */
    function isValidAssetItem(AssetItem memory assetItem) pure internal  returns(bool){
        return (
            bytes(assetItem.symbol).length > 0 &&
            assetItem.contractAddress != address(0) && 
            assetItem.isEnabled == true
        );
    }


    /**
     * @dev get all assets 
     */
     function getAllAssets() public view returns(AssetItem[] memory){

         AssetItem[] memory allAssetsDataArray  = new AssetItem[]  (totalAssets);

         //loop to get items
         // ids never starts  with  0, so start with  1
         for(uint256 i = 0; i <= totalAssets; i++){

             //lets now get asset  info 
             AssetItem memory assetItem = AssetsData[i];

             if(isValidAssetItem(assetItem)){

                assetItem.price  = _priceFeed.getPriceUSD(assetItem.symbol);
                allAssetsDataArray[i] = assetItem;
                 
             }
         }

        return allAssetsDataArray;
     } //end fun


} //end class

// File: @openzeppelin/contracts/utils/EnumerableSet.sol


pragma solidity ^0.6.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// File: @openzeppelin/contracts/access/AccessControl.sol


pragma solidity ^0.6.0;




/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: contracts/PermissionManager/PermissionManager.sol

pragma solidity ^0.6.2;



contract PermissionManager is Context, AccessControl {


    bytes32 ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 MODERATOR_ROLE =   keccak256("MODERATOR_ROLE");


    constructor(address _owner)  public {

      if(_owner  == address(0)){
        _owner = _msgSender();
      }

      //make deployer superAdmin
      _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        
      //add default roles
      _setupRole(ADMIN_ROLE,_owner);
      _setupRole(MODERATOR_ROLE, _owner);
      
    }  //end  

    /**
    * isSuperAdmin
    */
    function isSuperAdmin(address _address) public view  returns(bool) {
      return  super.hasRole(DEFAULT_ADMIN_ROLE,_address);
    }
     
    /**
    * isAdmin
    */
    function isAdmin(address _address) public view  returns(bool) {
        return super.hasRole(ADMIN_ROLE,_address) || super.hasRole(DEFAULT_ADMIN_ROLE,_address);
    }

    /**
     * isModerator
     */
    function isModerator(address _address) public view returns (bool) {
      return hasRole(MODERATOR_ROLE,_address) || isAdmin(_address);
    }

    /**
     * addNewRole
     */
     function addRole(bytes32 _roleName, address _memberAddress) public {
       require(isSuperAdmin(_msgSender()),"ONLY_SUPER_ADMINS_ALLOWED");
        super.grantRole(_roleName,_memberAddress);
     }

    /**
    * override the grantRole
    */
    function grantRole(bytes32 role, address account) public override virtual {}

}

// File: contracts/PaymentTypes/PaymentTypesCore.sol


pragma solidity ^0.6.2;


contract PaymentTypesCore is PM {

    uint256  totalCategories;
    uint256 totalPaymentTypes;


    constructor() public  {

      //default categories 
      _addCategory("Bank Transfers");
      _addCategory("Online Wallets");
      _addCategory("Cash Payments");
      _addCategory("Credit or Debit Cards");
      _addCategory("Gift Cards");
      _addCategory("Digital Currencies");
      _addCategory("Goods  & Services");
      _addCategory("Others");

    } //end function


    //paymentTypes categories
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => string) private  PaymentTypesCategories;

   //payment type struct
   struct PaymentTypeStruct {
      uint256 id;
      string  name;
      uint256 categoryId;
   }


    // paymentTypes 
    // format mapping(index => name)
    // NOTE  That the index always starts with 1 and not 0
    mapping(uint256 => PaymentTypeStruct) private PaymentTypesData;

   /**
   * @dev add a new payment type category
   * @param name category name in string
   * @return uint256 new category  id
   */
   function addCategory(string calldata name) external  onlyAdmins() returns(uint256) {
      return _addCategory(name);
   } //end fun 


   /**
   * @dev add a new payment type category
   * @param name category name in string
   * @return uint256 new  category id
   */
   function _addCategory(string memory name) private returns(uint256) {

      //get id
      uint256 id  = totalCategories++;

      PaymentTypesCategories[id] = name;

      return id;
   } //end fun 


   /**
   * @dev delete a cetegory
   * @param categoryId category  id
   */
   function deleteCateory(uint256 categoryId) external onlyAdmins() {
      delete  PaymentTypesCategories[categoryId];
   } //end fun 



    
   /**
   * @dev add a new payment type category
   * @param categoryId category id
   * @param categoryNewName  new category name to change
   */
   function updateCategory(uint256 categoryId,  string calldata categoryNewName) external  onlyAdmins() {
      PaymentTypesCategories[categoryId] = categoryNewName;
   } //end fun 


   /**
   * @dev add a new payment  type
   * @param name payment  type name
   * @param categoryId category id for the new payment  type
   * @return uint256
   */
   function addPaymentType(string memory name, uint256 categoryId ) public  onlyAdmins() returns(uint256) {

      //lets  check if categoryId exists 
      require(bytes(PaymentTypesCategories[categoryId]).length > 0,"UNKNOWN_CATEGORY");

      //avoid totalPaymentTypes++
      //counting starts from 1, so index 0 wont exist
      uint256 id  = totalPaymentTypes += 1;

      PaymentTypesData[id] = PaymentTypeStruct(id, name, categoryId);

      return id;
   } //end 

   /**
   * @dev remove  a payment type 
   * @param id  the payment type id
   */
   function removePaymentType(uint256 id) external  onlyAdmins() {
      delete PaymentTypesData[id];
   }


   /**
   *  @dev update  payment type info
   *  @param currentId old paymentType id
   *  @param newName the new name of the paymentType
   *  @param  newCategoryId the new category id of the payment type
   */
   function updatePaymentType(uint256 currentId, string calldata newName, uint256 newCategoryId) external  onlyAdmins()  {
      
      //lets check if 
      require(currentId  <= totalPaymentTypes,"XPIE:UNKNOWN_PAYMENT_TYPE");

      PaymentTypesData[currentId] = PaymentTypeStruct(currentId, newName, newCategoryId);

   } //end fun


   /**
   *  @dev get all payment types categories 
   *  @return  (string[] memory)
   *         CategoryNames Array
   */
   function  getAllCategories() external view returns (string[] memory ){
      
      string[] memory  categoriesArray = new string[] (totalCategories);
      
      //mapping index starts with 1, not  0
      for(uint256 i = 0; i < totalCategories; i++ ){
         categoriesArray[i] = PaymentTypesCategories[i];
      }

      return categoriesArray;
   } //end fun 

   /**
   * @dev get category by  id
   * @param id category id
   */
   function getCategoryById(uint256 id) external view returns (string  memory) {
      return PaymentTypesCategories[id];
   } //end fun 

   /* @dev get payment types using it category id
   * @param catId uint256 category id 
   * @return (string[]) paymentTypesArray
   */
   function getPaymentTypesByCatId(uint256 catId) external view returns(string[] memory ) {

      require(bytes(PaymentTypesCategories[catId]).length > 0, "XPIE:CATEGORY_NOT_FOUND");

      //lets fetch the  payment types ids
      string[] memory paymentTypesArray   = new string[] (totalPaymentTypes);

      for(uint256  i = 1; i < totalPaymentTypes; i++){
         if(PaymentTypesData[i].categoryId == catId){
            paymentTypesArray[i] = PaymentTypesData[i].name;
         }
      }

      return paymentTypesArray;
   }  //end fun


   /**
   * @dev getPaymentTypeById
   * @param id paymentType  id
   * return ( string, uint256, string) paymentType name, cetegoryId)
   */
   function  getPaymentTypeById(uint256 id) external  view returns(string memory, uint256) {
      return (PaymentTypesData[id].name, PaymentTypesData[id].categoryId);
   } //end fun 


   /**
   * @dev get all payment types 
   */
   function getAllPaymentTypes() external view returns( string[] memory, uint256[] memory) {

      string[]  memory  paymentTypesData;
      uint256[] memory  categoriesIds;

      for(uint256 i = 0; i < totalPaymentTypes; i++ ){
         paymentTypesData[i]    = PaymentTypesData[i].name;
         categoriesIds[i]       = PaymentTypesData[i].categoryId;
      }

      return (paymentTypesData, categoriesIds);
   }

}//end contract

// File: contracts/PaymentTypes/PaymentTypes.sol


pragma solidity ^0.6.2;



interface  IPaymentTypesCore  {
   function  getAllCategories() external view returns (string[] memory);
   function  getPaymentTypesByCatId(uint256 catId) external view returns( string[] memory );
   function  getCategoryById(uint256 id) external view returns (string memory);
   function  getAllPaymentTypes() external view returns( string[] memory, uint256[] memory);
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256);
   function  addCategory(string calldata name) external returns(uint256);
}

contract PaymentTypes is PM {

   //add category event
   event addPaymentTypeCategoryEvent(string name, uint256 id);

   // Payment types core contract  instance
    IPaymentTypesCore public PAYMENT_TYPES_CORE;
    
   /**
    * @dev  set the  payment types  db contract address internally
    */
    function _setPaymentTypesCoreAddress(address _newAddress) internal {
        PAYMENT_TYPES_CORE = IPaymentTypesCore(_newAddress);
    }

   /**
    * @dev set the  payment types  db contract address externally
    */
    function setPaymentTypesCoreAddress(address _newAddress) external onlySuperAdmins () {
       _setPaymentTypesCoreAddress(_newAddress);
    }

    /**
     * @dev  get all payment types categories  
     */
   function  getPaymentTypesCategories() external view returns (string[] memory){
      return PAYMENT_TYPES_CORE.getAllCategories();
   }
   
    
    /**
     * @dev get payment  type  by id
     * this helps us use  an external storage for the payment types
     * @param id payment  type id
     * return (string memory, uint256, string memory)
     *  paymentTypeName, categoryId
     */
   function  getPaymentTypeById(uint256 id) external view returns(string memory, uint256){
      return PAYMENT_TYPES_CORE.getPaymentTypeById(id);
   }

   /**
    * @dev get payment types  by cat  id
    * @param catId the category id
    * @return (string[]) 
    */
   function getPaymentTypesByCatId(uint256 catId) external view returns(string[] memory ){
      return PAYMENT_TYPES_CORE.getPaymentTypesByCatId(catId);
   }

   /**
    * @dev get all payment  types 
    *  return (uint256[], string[], uint256[])
    *  paymentTypeId  Array, paymentTypeName Array, categoryId Array
    */
   function getAllPaymentTypes() external view returns(string[] memory, uint256[] memory) {
      return PAYMENT_TYPES_CORE.getAllPaymentTypes(); 
   } // end 


   /**
    * @dev add Payment Type Category
    * @param name  payment type category name string
    * @return uint256
    */
    function  addPaymentTypeCategory(string calldata name) external returns(uint256){
       uint256 id = PAYMENT_TYPES_CORE.addCategory(name); 
       emit addPaymentTypeCategoryEvent(name,id);
       return id;
    }
}

// File: contracts/Factory.sol


pragma solidity ^0.6.2;

//PriceFeed is called in Assets.sol







//import  "./Oracles/OpenPriceFeed.sol";

contract Factory is  Assets,  PaymentTypes, PriceFeed {
    
    constructor() public {

        //initiate Permission Manager contracts
        PM._setPermissionManager(address(new PermissionManager(msg.sender)));

        // PaymentTypes  Core contract address
        PaymentTypes._setPaymentTypesCoreAddress(address(new PaymentTypesCore()));

        //configure  open price feed
        configureOpenPriceFeed();

    } //end fun 

    
    /**
     * @dev configure OpenPriceFeed
     */
    function configureOpenPriceFeed() private {

        uint256  chainId = getChainID();

        address feedContractAddress;
        

        //mainnet , default mainnet's address is  hardcoded in OpenPriceFeed.sol
        //if(chainId  == 1){ feedContractAddress = 0x922018674c12a7F0D394ebEEf9B58F186CdE13c1;  } // if ethereum mainnet
        if(chainId == 3){ feedContractAddress = 0xBEf4E076A995c784be6094a432b9CA99b7431A3f; }  // if ropsten
        else if(chainId == 42){  feedContractAddress = 0xbBdE93962Ca9fe39537eeA7380550ca6845F8db7; } //if kovan
        else {
            //revert("OpenPriceFeed: Unknown cahinId, kindly use  ropsten, kovan or mainnet");
        }

        //if we had the address then lets set it
        if(feedContractAddress != address(0)){
            //setUniswapAnchorContract is  in OpenPriceFeed which is inherited by PriceFeed 
            PriceFeed.configureOpenPriceFeed(feedContractAddress);
        }

    } //end fun 


    function getChainID() internal pure returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

} //end contract
