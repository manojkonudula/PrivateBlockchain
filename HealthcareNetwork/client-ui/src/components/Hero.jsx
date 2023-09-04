import React, { useState } from 'react'
import Signup from './Signup';

const Hero = () => {
    const [showModal, setShowModal] = useState(false);

    const handleSignupClick = () => {
        setShowModal(true);
    };

    return (
        <div className='text-white'>
            <div className='max-w-[800px] mt-[-96px] w-full pt-56 h-screen mx-auto text-center flex flex-col '>
                <p className='text-[#d239b8] font-bold p-2'>
                    YOUR GATEWAY TO CONNECTED WORLD
                </p>
                <h1 className='md:text-7xl sm:text-6xl text-4xl font-bold md:pt-6 pb-10'>
                    Secure, Immutable Records Management.
                </h1>
                <div className='flex justify-center items-center'>
                    <p className='md:text-5xl sm:text-4xl text-xl font-bold py-4'>
                        Connecting Organizations using Hyperledger Fabric Blockchain
                    </p>
                </div>
                <button className='bg-[#d239b8] w-[200px] rounded-md font-medium my-6 mx-auto py-3 text-white' onClick={handleSignupClick}>Sign Up</button>
            </div>
            {showModal && (
                    <div className="fixed z-[999] inset-0 overflow-y-auto">
                        <div className="flex items-end  min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                            <div className="fixed inset-0 transition-opacity" aria-hidden="true">
                                <div className="absolute inset-0 bg-gray-500 opacity-75"></div>
                            </div>

                            <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl 
                            transform transition-all sm:my-8 sm:align-middle ">
                                <Signup closeModal={() => setShowModal(false)} />
                            </div>
                        </div>
                    </div>
                )}
        </div>
    );
}

export default Hero