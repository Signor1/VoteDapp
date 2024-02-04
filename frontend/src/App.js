import { Field, Form, Formik } from "formik";
import { useState } from "react";
const Swal = require('sweetalert2')


function App() {
  const [hasVoted, setHasVote] = useState(false);

  return (
    <div className="container w-[80%] flex flex-col justify-center items-center mx-auto mt-[15%] py-12 px-6 border border-solid border-veryLightgrey rounded-lg md:w-[450px] md:mt-[5%] ">
      {hasVoted ? (
        <>
          <h1 className="text-3xl font-bold flex justify-center font-700 font-WorkSans">
            Election Data
          </h1>
          <h1 className="text-xl font-bold flex justify-center font-700 font-WorkSans">
            Total Voter: 25
          </h1>
          <h1 className="text-xl font-bold flex justify-center font-700 font-WorkSans">
            Total Votes: 20
          </h1>
          <div
            role="group"
            aria-labelledby="my-radio-group"
            className="flex flex-col"
          >
            <div className="my-2 flex justify-between items-center w-full gap-20">
              <label className="">Candidate 1</label>
              <h2 className="text-xl font-bold">15 Votes</h2>
            </div>
            <div className="my-2 flex justify-between items-center">
              <label className="my-2 flex justify-between">Candidate 2</label>
              <h2 className="text-xl font-bold">3 Votes</h2>
            </div>
            <div className="my-2 flex justify-between items-center">
              <label className="my-2 flex justify-between">Candidate 3</label>
              <h2 className="text-xl font-bold">2 Votes</h2>
            </div>
          </div>
        </>
      ) : (
        <>
          <div>
            <h1 className="text-3xl font-bold flex justify-center font-700 font-WorkSans">
              Hi, Welcome
            </h1>
            <p className="text-lightGrey text-center font-WorkSans">
              Vote for your preferred Candidate
            </p>
          </div>
          <Formik
            initialValues={{
              picked: "",
            }}
            onSubmit={async (values) => {
              await new Promise((r) => setTimeout(r, 500));
              alert(JSON.stringify(values, null, 2));
            }}
          >
            {({ values }) => (
              <Form>
                <div
                  role="group"
                  aria-labelledby="my-radio-group"
                  className="flex flex-col"
                >
                  <label className="my-2 flex gap-4">
                    <Field type="radio" name="picked" value="One" />
                    Candidate 1
                  </label>
                  <label className="my-2 flex gap-4">
                    <Field type="radio" name="picked" value="Two" />
                    Candidate 2
                  </label>
                  <label className="my-2 flex gap-4">
                    <Field type="radio" name="picked" value="Three" />
                    Candidate 3
                  </label>
                </div>
                <button
                  type="submit"
                  // disabled={isSubmitting}
                  className="text-white bg-black rounded-md p-1 md:p-1.5 font-Inter w-full mt-2"
                  onClick={()=>{setHasVote(true)
                    Swal.fire({
                      title: 'Congratulations',
                      text: 'You have successfully casted your vote',
                      icon: 'success',
                      confirmButtonText: 'See how the election is going'
                    })}}
                >
                  Cast Vote
                </button>
              </Form>
            )}
          </Formik>
        </>
      )}
    </div>
  );
}

export default App;
