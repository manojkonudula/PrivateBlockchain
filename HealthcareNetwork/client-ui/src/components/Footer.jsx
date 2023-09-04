import React from 'react'
import {
    FaFacebookSquare,
    FaInstagram,
    FaGithubSquare,
    FaTwitterSquare,
} from 'react-icons/fa';

const Footer = () => {
    return (
        <div className='max-w-[1240px] mx-auto py-10 px-4 text-gray-300'>
            <div className='flex justify-between mx-auto pb-6 w-full md:w-[50%]'>
                <span className='py-2 text-sm'>Claim</span>
                <span className='py-2 text-sm'>Policy</span>
                <span className='py-2 text-sm'>Terms</span>
            </div>
            <div className='flex justify-center w-full mx-auto md:w-[50%]'>
                
                <FaFacebookSquare size={22} />
                <FaInstagram size={22} className='ml-4'/>
                <FaGithubSquare size={22} className='ml-4'/>
                <FaTwitterSquare size={22} className='ml-4'/>
            </div>
        </div>
    )
}

export default Footer