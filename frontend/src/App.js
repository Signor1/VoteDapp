import { Field, Form, Formik } from "formik";

function App() {
   return (
  <div className="container w-[80%] flex flex-col justify-center items-center mx-auto mt-[15%] py-12 px-6 border border-solid border-veryLightgrey rounded-lg md:w-[450px] md:mt-[5%] ">
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
          <div role="group" aria-labelledby="my-radio-group" className="flex flex-col">
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
          >
            Cast Vote
          </button>
        </Form>
      )}
    </Formik>
  </div>
)}

export default App